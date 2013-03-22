package com.bouncingdata.plfdemo.datastore.pojo.model;

import java.util.Date;
import java.util.Set;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.Index;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;
import javax.jdo.annotations.Unique;

@PersistenceCapable
public class Tag {
  @PrimaryKey
  @Persistent(valueStrategy=IdGeneratorStrategy.INCREMENT)
  private int id;
  @Index
  private @Unique String tag;
  private int creator;
  private int popularity;
  private Date createAt;
  
  @Persistent(mappedBy="tags")
  Set<Analysis> analyses;
  
  public Set<Analysis> getAnalyses() {
    return analyses;
  }

  public Tag() {
    super();
  }
  
  public Tag(String tag) {
    super();
    this.tag = tag;
  }
  
  public int getId() {
    return id;
  }
  public void setId(int id) {
    this.id = id;
  }
  public String getTag() {
    return tag;
  }
  public void setTag(String tag) {
    this.tag = tag;
  }
  public int getCreator() {
    return creator;
  }
  public void setCreator(int creator) {
    this.creator = creator;
  }

  public int getPopularity() {
    return popularity;
  }

  public void setPopularity(int popularity) {
    this.popularity = popularity;
  }

  public Date getCreateAt() {
    return createAt;
  }

  public void setCreateAt(Date createAt) {
    this.createAt = createAt;
  }
}