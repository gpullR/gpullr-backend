package com.devbliss.gpullr.service;

import com.devbliss.gpullr.domain.PullRequest;
import com.devbliss.gpullr.domain.PullRequest.State;
import com.devbliss.gpullr.domain.User;
import com.devbliss.gpullr.exception.NotFoundException;
import com.devbliss.gpullr.repository.PullRequestRepository;
import com.devbliss.gpullr.repository.UserRepository;
import com.devbliss.gpullr.service.github.GithubApi;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Business facade for persisting and retrieving {@link PullRequest} objects.
 *
 * @author Henning Schütz <henning.schuetz@devbliss.com>
 */

@Service
public class PullRequestService {

  private final PullRequestRepository pullRequestRepository;

  private final UserRepository userRepository;

  private final GithubApi githubApi;

  @Autowired
  public PullRequestService(
      PullRequestRepository pullRequestRepository,
      UserRepository userRepository,
      GithubApi githubApi) {
    this.pullRequestRepository = pullRequestRepository;
    this.userRepository = userRepository;
    this.githubApi = githubApi;
  }

  public List<PullRequest> findAll() {

    return pullRequestRepository
      .findAll()
      .stream()
      .sorted((p1, p2) -> p1.createdAt.compareTo(p2.createdAt))
      .collect(Collectors.toList());
  }

  /**
   * Finds all open pull requests sorted by creation date, latest first.
   *
   * @return possibly empty list of pull requests
   */
  public List<PullRequest> findAllOpen() {
    return pullRequestRepository
      .findAllByState(PullRequest.State.OPEN)
      .stream()
      .sorted((p1, p2) -> p2.createdAt.compareTo(p1.createdAt))
      .collect(Collectors.toList());
  }

  public Optional<PullRequest> findById(Integer id) {
    return pullRequestRepository.findById(id);
  }

  public boolean exists(Integer id) {
    return pullRequestRepository.exists(id);
  }

  public void assignPullRequest(User user, Integer pullRequestId) {
    PullRequest pullRequest = pullRequestRepository
      .findById(pullRequestId)
      .orElseThrow(() -> new NotFoundException("No pullRequest found with id " + pullRequestId));

    if (isUserUnknown(user)) {
      throw new NotFoundException("Cannot assign unknown user " + user.username + " to a pullRequest.");
    }

    githubApi.assignUserToPullRequest(user, pullRequest);
    pullRequest.assignedAt = ZonedDateTime.now();
    pullRequest.assignee = user;
    pullRequestRepository.save(pullRequest);
  }

  public void insertOrUpdate(PullRequest pullRequest) {
    if (isUserUnknown(pullRequest.author)) {
      userRepository.save(pullRequest.author);
    }

    // assignee is null in GitHub response => save assignee if assigned via gpullr:
    pullRequestRepository
      .findById(pullRequest.id)
      .ifPresent(existing -> ensureAssignee(pullRequest, existing));

    if (pullRequest.state == State.CLOSED && pullRequest.closedAt == null) {
      pullRequest.closedAt = ZonedDateTime.now();
    }

    pullRequestRepository.save(pullRequest);
  }

  private void ensureAssignee(PullRequest pullRequestToEnsure, PullRequest fallback) {
    if (pullRequestToEnsure.assignee == null) {
      pullRequestToEnsure.assignee = fallback.assignee;

      if (fallback.assignedAt != null) {
        pullRequestToEnsure.assignedAt = fallback.assignedAt;
      } else {
        pullRequestToEnsure.assignedAt = ZonedDateTime.now();
      }
    }
  }

  private boolean isUserUnknown(User user) {
    return userRepository.findOne(user.id) == null;
  }
}
