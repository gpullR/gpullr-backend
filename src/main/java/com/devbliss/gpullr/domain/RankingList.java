package com.devbliss.gpullr.domain;

import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import javax.persistence.CollectionTable;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

@Entity
@Table(name = "RANKING_LIST")
public class RankingList {

  @Id
  @GeneratedValue(strategy = GenerationType.AUTO)
  public long id;

  @ElementCollection(fetch = FetchType.EAGER)
  @CollectionTable(name = "RANKING_LIST_RANKINGS")
  @NotNull
  private List<Ranking> rankings = new ArrayList<>();

  @NotNull
  public ZonedDateTime calculationDate;

  @NotNull
  @Enumerated(EnumType.STRING)
  public RankingScope rankingScope;

  public RankingList() {}

  public RankingList(List<Ranking> rankings, ZonedDateTime calculationDate, RankingScope rankingScope) {
    this.rankings = rankings;
    this.calculationDate = calculationDate;
    this.rankingScope = rankingScope;
  }

  public List<Ranking> getRankings() {
    return rankings
      .stream()
      .sorted((r1, r2) -> r2.closedCount.compareTo(r1.closedCount))
      .collect(Collectors.toList());
  }
}
