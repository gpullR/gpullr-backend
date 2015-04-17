package com.devbliss.gpullr.repository;

import com.devbliss.gpullr.domain.notifications.Notification;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.Optional;
import org.springframework.data.repository.CrudRepository;

/**
 * Created by abluem on 15/04/15.
 */
public interface NotificationRepository extends CrudRepository<Notification, Long> {

  List<Notification> findAll();

  Optional<Notification> findById(Long notificationId);

  List<Notification> findByReceivingUserIdAndSeenIsFalse(Long receivingUserId);

  Optional<Notification> findByPullRequestIdAndTimestamp(Integer pullRequestId, ZonedDateTime timestamp);
}