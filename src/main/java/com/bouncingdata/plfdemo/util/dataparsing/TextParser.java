package com.bouncingdata.plfdemo.util.dataparsing;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TextParser implements DataParser {
  
  private static final String LINE_BREAK = "\n";
  private static final String TAB = "\t";
  private static final String SEMICOLON = ";";
  private static final String COMMA = ",";
  
  private Logger logger = LoggerFactory.getLogger(TextParser.class);
  
  protected TextParser() {};

  @Override
  public List<Object[]> parse(InputStream is) throws Exception {
    Scanner scanner = new Scanner(is);
    List<Object[]> results = new ArrayList<Object[]>();
    boolean isFirst = true;
    int columnNum = 0;
    while (scanner.hasNextLine()) {
      String line = scanner.nextLine();
      String[] array = line.split("[\t,;]");
      if (isFirst) {
        columnNum = array.length;
        results.add(array);
      }
      else {
        if (array.length < columnNum) {
          String[] fixedArray = new String[columnNum];
          for (int i = 0; i < columnNum; i++) {
            if (i < array.length) {
              fixedArray[i] = array[i];
            } else {
              fixedArray[i] = null;
            }
          }
          results.add(fixedArray);
        } else {
          results.add(array);
        }
      }
      isFirst = false;
    }
    return results;
  }
  
  public static void main(String[] args) throws Exception {
    File file = new File("/home/khiem/Downloads/NASDAQ.txt");
    TextParser parser = new TextParser();
    List<Object[]> results = parser.parse(new FileInputStream(file));
    System.out.println("Number of line: " + results.size());
  }

  @Override
  public List<DatasetColumn> parseSchema(InputStream is) throws Exception {
    throw new Exception("Temporarily disabled the text support");
  }

}
