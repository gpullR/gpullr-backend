package com.devbliss.gpullr.controller.dto.notification;

import com.devbliss.gpullr.domain.notifications.SystemNotificationType;
import java.time.ZonedDateTime;

/**
 * Created by abluem on 13/05/15.
 */
public class SystemNotificationDto {
  public String validUntil;

  public SystemNotificationType notificationType;

}