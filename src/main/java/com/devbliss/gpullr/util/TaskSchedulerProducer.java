package com.devbliss.gpullr.util;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;

/**
 * Produces instances of {@link TaskScheduler} which are already initialized and ready for use.
 * 
 * @author Henning Schütz <henning.schuetz@devbliss.com>
 *
 */
@Configuration
public class TaskSchedulerProducer {
  
  @Bean
  public TaskScheduler createThreadPoolTaskScheduler() {
    ThreadPoolTaskScheduler executor = new ThreadPoolTaskScheduler();
    executor.initialize();
    return executor;
  }
}