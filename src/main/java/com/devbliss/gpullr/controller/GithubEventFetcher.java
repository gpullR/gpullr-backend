package com.devbliss.gpullr.controller;

import com.devbliss.gpullr.domain.Repo;
import com.devbliss.gpullr.domain.RepoCreatedEvent;
import com.devbliss.gpullr.service.RepoService;
import com.devbliss.gpullr.service.github.GithubApi;
import com.devbliss.gpullr.service.github.GithubEventsResponse;
import com.devbliss.gpullr.service.github.PullRequestEventHandler;
import com.devbliss.gpullr.util.Log;
import java.time.Instant;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.Scope;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.stereotype.Component;

/**
 * Fetches pull requests for all our repositories. Must be started once using {@link #startFetchEventsLoop()}.
 * Afterwards, it independently polls periodically according to the poll interval returned by GitHub.
 * 
 * The actual business logic for handling the fetched events takes place in {@link PullRequestEventHandler}.
 *
 * @author Henning Schütz <henning.schuetz@devbliss.com>
 */
@Component
@Scope(ConfigurableBeanFactory.SCOPE_SINGLETON)
public class GithubEventFetcher implements ApplicationListener<RepoCreatedEvent> {

  @Log
  private Logger logger;

  @Autowired
  private GithubApi githubApi;

  @Autowired
  private RepoService repoService;

  @Autowired
  private PullRequestEventHandler pullRequestEventHandler;

  private ThreadPoolTaskScheduler executor;

  public GithubEventFetcher() {
    executor = new ThreadPoolTaskScheduler();
    executor.initialize();
    executor.setPoolSize(600);
  }

  /**
   * Starts the fetching loop. Must be called once at application start.
   */
  public void startFetchEventsLoop() {
    List<Repo> allRepos = repoService.findAll();
    logger.info("Start fetching events from GitHub for all " + allRepos.size() + " repos...");
    int counter = 1;

    for (Repo repo : allRepos) {
      logger.debug("Fetching events for repo: " + repo.name + " ( " + counter + ". in list )");
      fetchEvents(repo, Optional.empty());
      counter++;
    }
  }

  /**
   * Adds new repo to the fetching loop.
   * 
   * @param repo
   */
  @Override
  public void onApplicationEvent(RepoCreatedEvent event) {
    logger.debug("Added new repo to fetch events loop: " + event.createdRepo.name);
    fetchEvents(event.createdRepo, Optional.empty());
  }

  private void fetchEvents(Repo repo, Optional<String> etagHeader) {
    handleEventsResponse(githubApi.fetchAllEvents(repo, etagHeader), repo);
  }

  private void handleEventsResponse(GithubEventsResponse response, Repo repo) {
    response.pullRequestEvents.forEach(pullRequestEventHandler::handlePullRequestEvent);
    Date start = Date.from(Instant.now().plusSeconds(response.nextRequestAfterSeconds));
    executor.schedule(() -> fetchEvents(repo, response.etagHeader), start);
    logger.debug("Fetched "
        + response.pullRequestEvents.size()
        + " PR events for " + repo.name
        + " / active threads in executor="
        + executor.getActiveCount() + ", queueSize="
        + executor.getScheduledThreadPoolExecutor().getQueue().size());

  }
}
