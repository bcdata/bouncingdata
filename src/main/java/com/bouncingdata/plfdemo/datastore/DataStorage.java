package com.bouncingdata.plfdemo.datastore;

import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Set;

import org.springframework.dao.DataAccessException;

import com.bouncingdata.plfdemo.datastore.pojo.dto.SearchResult;
import com.bouncingdata.plfdemo.datastore.pojo.model.Activity;
import com.bouncingdata.plfdemo.datastore.pojo.model.Analysis;
import com.bouncingdata.plfdemo.datastore.pojo.model.AnalysisDataset;
import com.bouncingdata.plfdemo.datastore.pojo.model.AnalysisVote;
import com.bouncingdata.plfdemo.datastore.pojo.model.BcDataScript;
import com.bouncingdata.plfdemo.datastore.pojo.model.Comment;
import com.bouncingdata.plfdemo.datastore.pojo.model.CommentVote;
import com.bouncingdata.plfdemo.datastore.pojo.model.DataCollection;
import com.bouncingdata.plfdemo.datastore.pojo.model.Dataset;
import com.bouncingdata.plfdemo.datastore.pojo.model.DatasetVote;
import com.bouncingdata.plfdemo.datastore.pojo.model.ExecutionLog;
import com.bouncingdata.plfdemo.datastore.pojo.model.Following;
import com.bouncingdata.plfdemo.datastore.pojo.model.Group;
import com.bouncingdata.plfdemo.datastore.pojo.model.PageView;
import com.bouncingdata.plfdemo.datastore.pojo.model.ReferenceDocument;
import com.bouncingdata.plfdemo.datastore.pojo.model.Scraper;
import com.bouncingdata.plfdemo.datastore.pojo.model.Tag;
import com.bouncingdata.plfdemo.datastore.pojo.model.User;
import com.bouncingdata.plfdemo.datastore.pojo.model.Visualization;

/**
 * @author khiem
 */
/**
 * @author khiem
 *
 */
public interface DataStorage {

  /**
   * Retrieves all <code>Dataset</code>s owned by an user.
   * @param userId the user id to retrieve
   * @return a <code>List</code> of <code>Dataset</code> objects
   * @throws DataAccessException
   */
  public List<Dataset> getDatasetList(int userId);
  
  public Dataset getDatasetByName(String identifier);
  
  /**
   * Retrieves all <code>Analysis</code>s owned by an user.
   * @param user the user id to retrieve
   * @return a <code>List</code> of <code>Analysis</code> objects
   * @throws DataAccessException
   */
  public List<Analysis> getAnalysisList(int userId);
  
  /**
   * Retrieves all private <code>Analysis</code>s owned by user.
   * @param user user id to retrieve
   * @return <code>List</code> of <code>Analysis</code>
   * @throws DataAccessException
   */
  public List<Analysis> getPrivateAnalyses(int userId);
  
  /**
   * Retrieves all public <code>Analysis</code>s by user
   * @param user user id
   * @return <code>List</code> of <code>Analysis</code>
   * @throws DataAccessException
   */
  public List<Analysis> getPublicAnalyses(int userId);
    
  /**
   * Finds the <code>User</code> by username.
   * @param username the username
   * @return <code>User</code> object, or null if not found
   */
  public User findUserByUsername(String username);
  
  /**
   * Finds the <code>User</code> by email. The email is unique in whole system.
   * @param email the email
   * @return<code>User</code> object, or null if no email found.
   */
  public User findUserByEmail(String email);
  
  /**
   * Gets the <code>ExecutionLog</code> detail by execution id.
   * @param executionId the execution id
   * @return an <code>ExecutionLog</code> object
   * @throws DataAccessException
   */
  public ExecutionLog getExecutionLog(String executionId);
  
  /**
   * Retrieves all <code>Dataset</code>s related to an <code>Analysis</code>
   * @param analysisId the analysis id
   * @return a <code>List</code> of <code>Dataset</code>s
   * @throws DataAccessException
   */
  public List<AnalysisDataset> getAnalysisDatasets(int analysisId);
  
  /**
   * Retrieves all <code>Visualization</code>s related to an <code>Analysis</code>.
   * @param analysisId the analysis id
   * @return a <code>List</code> of <code>Visualization</code>s
   * @throws DataAccessException
   */
  public List<Visualization> getAnalysisVisualizations(int analysisId);
  
  /**
   * Searches Analysiss and datasets by query string.
   * @param query the query string
   * @return <code>SearchResult</code> object
   * @throws DataAccessException
   */
  public SearchResult search(String query);
  
  /**
   * Creates new user
   * @param user the <code>User</code> object
   * @throws DataAccessException
   */
  public void createUser(User user);
  
  /**
   * @param group the <code>Group</code> object
   * @throws DataAccessException
   */
  public void createGroup(Group group);
  
  /**
   * @param analysis the <code>Analysis</code>
   * @throws DataAccessException
   */
  public void createAnalysis(Analysis analysis);
  
  /**
   * @param analysis
   * @throws DataAccessException
   */
  public void updateAnalysis(Analysis analysis);
  
  public void updateScraper(Scraper scraper);
  
  public boolean updateDataset(Dataset dataset);
  /**
   * @param analysisId
   * @throws DataAccessException
   */
  public void deleteAnalysis(int analysisId);
  
  /**
   * @param analysisId the id of analysis
   * @return
   * @throws DataAccessException
   */
  public Analysis getAnalysis(int analysisId);
  
  /**
   * @param guid
   * @throws DataAccessException
   */
  public Analysis getAnalysisByGuid(String guid);
  
  /**
   * @param userId
   * @return
   * @throws DataAccessException
   */
  public User getUser(int userId);
    
  /**
   * @param userId
   * @return
   * @throws DataAccessException
   */
  public Collection<String> getUserAuthorities(int userId);
  
  /*public List<Object> readDataset(String dataset);*/
  
  public Scraper getScraperByGuid(String guid);
  
  /**
   * @param scraper
   */
  public void createBcDataScript(BcDataScript script);
  
  /**
   * @param scraper
   */
  public void updateBcDataScript(BcDataScript script);
  
  /**
   * @param scraperId
   */
  public void deleteBcDataScript(int scriptId, String type);
  
  
  /**
   * @param visualization
   * @throws DataAccessException
   */
  public void createVisualization(Visualization visualization); 
  
  /**
   * @param guid
   * @return
   * @throws DataAccessException
   */
  public Dataset getDatasetByGuid(String guid);
      
  /**
   * Update status of the analysis dashboard
   * @param guid the guid of analysis
   * @param status the dashboard status to save
   * @throws DataAccessException
   */
  public void updateDashboard(String guid, String status);
  
  /**
   * @param app
   * @throws DataAccessException
   */
  public void invalidateViz(Analysis app);
  
  /**
   * @param analysisId
   * @return
   * @throws DataAccessException
   */
  public List<Comment> getComments(int analysisId);
  
  /**
   * @param userId
   * @param analysisId
   * @param comment
   * @throws DataAccessException
   */
  public void addComment(int userId, int analysisId, Comment comment);
  
  /**
   * @param commentId
   * @throws DataAccessException
   */
  public void removeComment(int commentId);
  
  /**
   * @param comment
   * @throws DataAccessException
   */
  public void updateComment(Comment comment);
  
  /**
   * @param commentId
   * @return
   * @throws DataAccessException
   */
  public Comment getComment(int commentId);
  
  /**
   * @param userId
   * @param commentId
   * @return
   * @throws DataAccessException
   */
  public CommentVote getCommentVote(int userId, int commentId);
  
  /**
   * @param userId
   * @param commentId
   * @param commentVote
   * @throws DataAccessException
   */
  public void addCommentVote(int userId, int commentId, CommentVote commentVote);
  
  /**
   * @param userId
   * @param commentId
   * @throws DataAccessException
   */
  public void removeCommentVote(int userId, int commentId);
  
  /**
   * @param userId
   * @param analysisId
   * @return
   * @throws DataAccessException
   */
  public AnalysisVote getAnalysisVote(int userId, int analysisId);
  
  /**
   * @param userId
   * @param analysisId
   * @param analysisVote
   * @throws DataAccessException
   */
  public void addAnalysisVote(int userId, int analysisId, AnalysisVote analysisVote);
  
  /**
   * @param userId
   * @param analysisId
   * @throws DataAccessException
   */
  public void removeAnalysisVote(int userId, int analysisId);
  
  
  
  /**
   * @param activityId
   * @return
   * @throws DataAccessException
   */
  public Activity getActivity(int activityId);
  
  /**
   * @param activity
   * @throws DataAccessException
   */
  public void createActivity(Activity activity);
  
  /**
   * @param activityId
   * @throws DataAccessException
   */
  public void removeActivity(int activityId);
  
  /**
   * @param activity
   * @throws DataAccessException
   */
  public void updateActivity(Activity activity);
  
  /**
   * @param userId
   * @param cutPoint
   * @return
   * @throws DataAccessException
   */
  public List<Activity> getUserActitity(int userId, Date cutPoint);
  
  /**
   * @param userId
   * @return
   * @throws DataAccessException
   */
  public List<Following> getFollowingList(int userId) ;
  
  /**
   * Retrieves list of users which is following this user
   * @param userId
   * @return <code>List</code> of <code>User</code> objects
   * @throws DataAccessException
   */
  public List<User> getFollowers(int userId);
  
  /**
   * Retrieves list of users which this user is currently following
   * @param userId
   * @return
   * @throws DataAccessException
   */
  public List<User> getFollowingUsers(int userId);
 
  /**
   * @param userId
   * @param cutPoint
   * @return
   * @throws DataAccessException
   */
  //public List<Activity> getFeed(int userId, Date cutPoint, int maxNumber);
  public List<Activity> getFeed(int userId, int maxNumber);
  
  public List<Activity> getMoreFeed(int userId, List<Following> followings, int lastId, int maxNumber);
  
  /**
   * Finds friends for a <code>finder</code> user.
   * @param finder the finder
   * @param query the query string
   * @return <code>List</code> of <code>User</code> objects
   * @throws DataAccessException
   */
  public List<User> findFriends(User finder, String query);
  
  /**
   * Creates a new connection from a follower to a target user
   * @param follower the follower user id
   * @param target the target user id
   * @throws DataAccessException
   */
  public void createFollowing(int follower, int target);
  
  /**
   * Removes connection(s) between a follower and a target user.
   * @param follower the follower user id
   * @param target the target user id
   * @throws DataAccessException
   */
  public void removeFollowing(int follower, int target);
  
  /**
   * @param follower
   * @param target
   * @return
   */
  /**
   * @param follower
   * @param target
   * @return
   */
  public boolean isFollowing(int follower, int target);
  
  /**
   * @param dataset
   */
  /**
   * @param dataset
   */
  public void createDataset(Dataset dataset);
  
  /**
   * @param datasets
   */
  public void createDatasets(List<Dataset> datasets);
  
  /**
   * Invalidates (or removes?) all datasets which generated by an analysis
   * @param app
   */
  public void invalidateDataset(Scraper scraper);
  
  /**
   * @param scraperId
   * @return
   */
  public List<Dataset> getScraperDatasets(int scraperId);
  
  /**
   * @param userId
   * @return
   */
  public List<Scraper> getScraperList(int userId);
  
  /**
   * @param userId
   * @return
   */
  public List<Scraper> getPublicScrapers(int userId);
  
  public void invalidateDatasets(Analysis analysis);
  
  public void createAnalysisDatasets(List<AnalysisDataset> anlsDts);

  List<AnalysisDataset> getRelatedAnalysis(int datasetId);

  SearchResult search(String query, int ownerId);
  
  public void createDataCollection(DataCollection collection);
  
  public void deleteDataCollection(int collectionId);
  
  public void updateDataCollection(DataCollection collection);
  
  public DataCollection getDataCollection(int collectionId);
  
  public List<DataCollection> getUserCollections(int userId);
  
  public void deleteUserCollections(int userId);
  
  public void addDatasetToCollection(int datasetId, int collectionId);
  
  public List<Analysis> getMostPopularAnalyses();
  
  //----- Vinhpq : adding temporary functions for left menu ----
  
  public DatasetVote getDatasetVote(int userId, int dsId);
  
  public void addDatasetVote(int userId, int dsId, DatasetVote dsVote);
  
  public void removeDatasetVote(int userId, int dsId);
  
  public List<Dataset> getMostPopularDatasets(int maxnumber);
  
  public List<Analysis> getMostPopularAnalyses(int maxnumber);
  
  public List<Analysis> getAllAnalysesBySelf(int userId ,int startPoint ,int maxNumber);

  public List<Dataset> getAllDatasetsBySelf(int userId ,int startPoint ,int maxNumber);

  public List<Dataset> getPopularDatasetsBySelf(int userId ,int startPoint ,int maxNumber);

  public List<Analysis> getPopularAnalysesBySelf(int userId ,int startPoint ,int maxNumber);
  
  public List<Analysis> getAnalysesIn1Month(int startPoint, int numrows);
  
  public List<Dataset> getDatasetsIn1Month(int startPoint, int numrows);
  
  public List<Analysis> getPopularAnalysesIn1Month(int startPoint, int numrows);
  
  public List<Dataset> getPopularDatasetsIn1Month(int startPoint, int numrows);
  
  public List<Analysis> getRecentAnalysisStaffPick(int startPoint, int maxNumber);
  
  public List<Dataset> getRecentDatasetsStaffPick(int startPoint, int maxNumber);
  
  public List<Dataset> getPopularDatasetsStaffPick(int startPoint, int maxNumber);

  public List<Analysis> getPopularAnalysesStaffPick(int startPoint, int maxNumber);
  
  public List<Tag> get10Tags();
  
  public boolean removeDataset(int dsId);
  
  public boolean removeAnalysis(int anlsId);
  
  public void resetPassword(int userId, String newpass);
  
  public void changeActiveRegisterStatus(int userId);
  
  public void addSttResetPassword(int userId, String activecode, String expiredDate);
  
  public List<Analysis> get20AuthorAnalysesRecent(int startPoint, int maxNumber);

  public List<Dataset> get20AuthorDataSetRecent(int startPoint, int maxNumber);
  
  public List<Dataset> get20AuthorDataSetItemPopular(int startPoint, int maxNumber);
  
  public List<Analysis> get20AuthorAnalysesItemPopular(int startPoint, int maxNumber);
  
  //-----
  
  public List<Dataset> getMostPopularDatasets();
  
  /*Add for tag features*/
  public void createTag(Tag tag);  

  public void addAnalysisTag(int anlsId, int tagId);
  public void deleteAnalysisTag(int anlsId, int tagId);
  /*How many tag for an analysis*/
  public Set<Tag> getTagByAnalysis(int anlsId);
  public List<Analysis> getAnalysisByTag(int tagId);
 
  public void addScraperTag(int scId, int tagId);
  public void deleteScraperTag(int scId, int tagId);
  /*How many tag for a Scraper*/
  public Set<Tag> getTagByScraper(int scId);
  public List<Scraper> getScraperByTag(int tagId);
  
  
  public void addDatasetTag(int dsId, int tagId);
  public void deleteDatasetTag(int dsId, int tagId);
  /*How many tag for a DataSet*/
  public Set<Tag> getTagByDataset(int dsId);
  public List<Dataset> getDatasetByTag(int tagId);

  Tag getTag(String tagStr);

  void addAnalysisTags(int anlsId, List<Tag> tags);

  void createTags(List<Tag> tags);

  List<Analysis> getMostRecentAnalyses(int maxNumber);

  List<Analysis> getMoreRecentAnalyses(int lastId, int maxNumber);
  
  public void logUserAction(int userId,int actionCode,String data);

  void addDatasetRefDocument(int dsId, ReferenceDocument refDoc);
  
  void addDatasetTags(int dtsId, List<Tag> tags);

  void removeDatasetTag(int dtsId, int tagId);

  void removeDatasetTags(int dtsId, List<Tag> tags);
  
  int increasePageView(int objectId, String type);
  
  PageView getPageView(int objectId, String type);
  List<Tag>  getTags(int num);
  /**
   * @param userId
   * @return
   * @throws DataAccessException
   */
  /*public int getPost(int userId);*/
    
}

