package com.bouncingdata.plfdemo.datastore;

import java.util.Date;

import javax.jdo.annotations.Column;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.bouncingdata.plfdemo.datastore.pojo.model.User;

@PersistenceCapable
public class UserActionLog {
	/*
	 * Define action type 
	 */
	
	public UserActionLog(int actionType){
		actionTypeID = actionType;
	}
	
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private int actionID;

	@Column(name="id")
    User user;
	public void setUser(User in){
		user = in;
	}
	
	public int getId() {
		return actionID;
	}

	public void setId(int id) {
		this.actionID = id;
	}
	
	private int actionTypeID;
	Date	beginDate;
	Date	endDate;
	long start;
	long end;
	long diff;
	public void startLog(){
		start = System.currentTimeMillis( );
		beginDate = new Date();
	}
	public void stopLog(){
		end = System.currentTimeMillis( );
		endDate = new Date();
		diff = end - start;
	}
	public long getActionTime(){		
		return diff;
	}

	public int getActionTypeID() {
		return actionTypeID;
	}

	public void setActionTypeID(int actionTypeID) {
		this.actionTypeID = actionTypeID;
	}
	
	public static class ActionType{
		public static int GETDATASETLIST = 1 ;
		public static int GETDATASETBYNAME = 2 ;
		public static int GETANALYSISLIST = 3 ;
		public static int GETPRIVATEANALYSES = 4 ;
		public static int GETANALYSES = 5 ;
		public static int FINDUSERBYUSERNAME = 6 ;
		public static int FINDUSERBYEMAIL = 7 ;
		public static int GETEXECUTIONLOG = 8 ;
		public static int GETANALYSISDATASETS = 9 ;
		public static int GETANALYSISVISUALIZATIONS = 10 ;
		public static int SEARCH = 11 ;
		public static int CREATEUSER = 12 ;
		public static int CREATEGROUP = 13 ;
		public static int CREATEANALYSIS = 14 ;
		public static int UPDATEANALYSIS = 15 ;
		public static int DELETEANALYSIS = 16 ;
		public static int GETANALYSIS = 17 ;
		public static int GETANALYSISBYGUID = 18 ;
		public static int GETUSER = 19 ;
		public static int GETUSERAUTHORITIES = 20 ;
		public static int READDATASET = 21 ;
		public static int GETSCRAPERBYGUID = 22 ;
		public static int CREATEBCDATASCRIPT = 23 ;
		public static int UPDATEBCDATASCRIPT = 24 ;
		public static int DELETEBCDATASCRIPT = 25 ;
		public static int CREATEVISUALIZATION = 26 ;
		public static int GETDATASETBYGUID = 27 ;
		public static int UPDATEDASHBOARD = 28 ;
		public static int INVALIDATEVIZ = 29 ;
		public static int GETCOMMENTS = 30 ;
		public static int ADDCOMMENT = 31 ;
		public static int REMOVECOMMENT = 32 ;
		public static int UPDATECOMMENT = 33 ;
		public static int GETCOMMENT = 34 ;
		public static int GETCOMMENTVOTE = 35 ;
		public static int ADDCOMMENTVOTE = 36 ;
		public static int REMOVECOMMENTVOTE = 37 ;
		public static int GETANALYSISVOTE = 38 ;
		public static int ADDANALYSISVOTE = 39 ;
		public static int REMOVEANALYSISVOTE = 40 ;
		public static int GETACTIVITY = 41 ;
		public static int CREATEACTIVITY = 42 ;
		public static int REMOVEACTIVITY = 43 ;
		public static int UPDATEACTIVITY = 44 ;
		public static int GETUSERACTITITY = 45 ;
		public static int GETFOLLOWINGLIST = 46 ;
		public static int GETFOLLOWERS = 47 ;
		public static int GETFOLLOWINGUSERS = 48 ;
		public static int GETFEED = 49 ;
		public static int GETMOREFEED = 50 ;
		public static int FINDFRIENDS = 51 ;
		public static int CREATEFOLLOWING = 52 ;
		public static int REMOVEFOLLOWING = 53 ;
		public static int CREATEDATASET = 54 ;
		public static int CREATEDATASETS = 55 ;
		public static int INVALIDATEDATASET = 56 ;
		public static int GETSCRAPERDATASETS = 57 ;
		public static int GETSCRAPERLIST = 58 ;
		public static int GETSCRAPERS = 59 ;
		public static int INVALIDATEDATASETS = 60 ;
		public static int CREATEANALYSISDATASETS = 61 ;
		public static int GETRELATEDANALYSIS = 62 ;
		public static int CREATEDATACOLLECTION = 63 ;
		public static int DELETEDATACOLLECTION = 64 ;
		public static int UPDATEDATACOLLECTION = 65 ;
		public static int GETDATACOLLECTION = 66 ;
		public static int GETUSERCOLLECTIONS = 67 ;
		public static int DELETEUSERCOLLECTIONS = 68 ;
		public static int ADDDATASETTOCOLLECTION = 69 ;
		public static int GETMOSTPOPULARANALYSES = 70 ;
		public static int GETMOSTPOPULARDATASETS = 71 ;
		public static int CREATETAG = 72 ;
		public static int ADDANALYSISTAG = 73 ;
		public static int DELETEANALYSISTAG = 74 ;
		public static int GETTAGBYANALYSIS = 75 ;
		public static int GETANALYSISBYTAG = 76 ;
		public static int ADDSCRAPERTAG = 77 ;
		public static int DELETESCRAPERTAG = 78 ;
		public static int GETTAGBYSCRAPER = 79 ;
		public static int GETSCRAPERBYTAG = 80 ;
		public static int ADDDATASETTAG = 81 ;
		public static int DELETEDATASETTAG = 82 ;
		public static int GETTAGBYDATASET = 83 ;
		public static int GETDATASETBYTAG = 84 ;
		public static int GETPUBLICANALYSES = 85 ;

		
		
	}
}
