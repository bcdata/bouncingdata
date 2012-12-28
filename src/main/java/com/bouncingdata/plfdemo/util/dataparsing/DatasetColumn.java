package com.bouncingdata.plfdemo.util.dataparsing;

import org.codehaus.jackson.annotate.JsonIgnore;

public class DatasetColumn {
  private String name;
  private Class typeClass;
  private String typeName;
  
  public DatasetColumn(String name) {
    this.name = name;
  }
  
  @JsonIgnore
  public Class getTypeClass() {
    return typeClass;
  }

  public void setTypeClass(Class typeClass) {
    this.typeClass = typeClass;
  }

  public String getTypeName() {
    return typeName;
  }

  public void setTypeName(String typeName) {
    this.typeName = typeName;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }
}
