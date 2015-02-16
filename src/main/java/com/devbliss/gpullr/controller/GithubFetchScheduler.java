package com.devbliss.gpullr.controller;

import java.time.Instant;
import java.util.Date;
import javax.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.stereotype.Component;

/**
 * Starts / coordinates the fetching of data from GithubAPI. 
 * Starts fetching repos and users first, and after ({@link #START_EVENTSLOOP_AFTER_SECONDS}) seconds
 * fetching the pull requests for the repos. 
 * 
 * @author Henning Schütz <henning.schuetz@devbliss.com>
 *
 */
@Component
public class GithubFetchScheduler {

  private static final int START_EVENTSLOOP_AFTER_SECONDS = 60;

  private ThreadPoolTaskScheduler executor;

  @Autowired
  private GithubReposFetcher githubReposRefresher;

  @Autowired
  private GithubEventFetcher githubEventFetcher;

  @Autowired
  private GithubUserFetcher githubUserFetcher;

  public GithubFetchScheduler() {
    executor = new ThreadPoolTaskScheduler();
    executor.initialize();
  }

  @PostConstruct
  public void startExecution() {
    Date startEventsLoop = Date.from(Instant.now().plusSeconds(START_EVENTSLOOP_AFTER_SECONDS));
    executor.execute(() -> githubReposRefresher.fetchRepos());
    executor.execute(() -> githubUserFetcher.fetchUsers());
    executor.schedule(() -> startFetchEventsLoop(), startEventsLoop);
  }

  private void startFetchEventsLoop() {
    githubEventFetcher.startFetchEventsLoop();
  }
}
