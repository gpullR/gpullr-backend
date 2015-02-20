package com.devbliss.gpullr.service;

import com.devbliss.gpullr.domain.User;
import com.devbliss.gpullr.exception.LoginRequiredException;
import com.devbliss.gpullr.repository.UserRepository;
import com.devbliss.gpullr.session.UserSession;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Business Layer for {@link com.devbliss.gpullr.domain.User} objects.
 *
 * @author Henning Schütz <henning.schuetz@devbliss.com>
 */
@Service
public class UserService {

  private final UserRepository userRepository;

  private UserSession userSession;

  @Autowired
  public UserService(UserRepository userRepository, UserSession userSession) {
    this.userRepository = userRepository;
    this.userSession = userSession;
  }

  public void insertOrUpdate(User user) {
    userRepository.save(user);
  }

  public List<User> findAll() {
    return userRepository.findAll();
  }

  public List<User> findAllOrgaMembers() {
    return userRepository.findByCanLoginIsTrue();
  }

  public void requireLogin() throws LoginRequiredException {
    if (userSession.getUser() == null) {
      throw new LoginRequiredException();
    }
  }

  public void login(int id) {
    User loggedInUser = userRepository.findOne(id);
    userSession.setUser(loggedInUser);
  }

  public User whoAmI() {
    requireLogin();
    return userSession.getUser();
  }
}
