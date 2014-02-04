package log4plsql.backgroundProcess;

/* Class DbConn - Super class for a database connection
 * 
 *  The constructor verifies the syntax of the JDBC URL
 * 
 */
 

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Hashtable;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;

public class DbConn {
	private static Logger logger = Logger.getLogger("backgroundProcess.DbConn");
	
	// variables for DB connection
	String JDBCurl;
	String HostName; 
	int    PortNr;   
	String SID;      
	String DbUser;
	String DbPass;
	String QueueName;
	  
	boolean formatOK;  // true: JDBC URL is OK
	boolean connected; // true: connected to the queue
	  
	public DbConn(String pJDBC, String pDBUser, String pDBPass, String pQueueName)
	{
		String[] conn_array = null; 
			
		formatOK = false;
		connected = false;
				
		JDBCurl = pJDBC.toLowerCase();
		
		// verify the syntax of the JDBC URL
		if (JDBCurl.startsWith("jdbc:oracle:thin")) 
		{
			conn_array = JDBCurl.split(":");
			if (conn_array.length == 6) 
			{
				HostName = conn_array[3].replaceAll("@", "");
				PortNr = Integer.parseInt(conn_array[4]);
				SID = conn_array[5];
					
				DbUser = pDBUser;
				DbPass = pDBPass;
				QueueName = pQueueName;
					
				formatOK = true;
			}
			else
			{
				logger.fatal("DB Configuration error - Please verify the JDBC url");
			}
		}
		else
		{
			logger.fatal("DB Configuration error - JDBC url must begin with jdbc:oracle:thin");
		}
	}
	  
	/* return the mapping between PL/SQL and LOG4J log levels in a hash table */
	public Hashtable getLogLevels()
	{
		Hashtable htLevels = new Hashtable(); 
		Statement statement;
		String SQLQuery = "SELECT LJLEVEL, LCODE, nvl(LSYSLOGEQUIV,LLEVEL)  LSYSLOGEQUIV " +
	                      "FROM TLOGLEVEL " +
			              "ORDER BY LLEVEL";
		ResultSet rs = null;
		Connection jdbc_conn = null; 
					
		if (formatOK == false)
		{
			logger.log(Level.FATAL, "Connection parameters are not OK");		
		}
		else
		{	
			try{
				// connect to database
				Class.forName("oracle.jdbc.driver.OracleDriver");
				jdbc_conn = DriverManager.getConnection(JDBCurl, DbUser, DbPass);
					
				logger.debug( "JDBC Connection OK: " + jdbc_conn.toString());
					
				// get the PL/SQL and corresponding LOG4J log levels
				statement = jdbc_conn.createStatement();
				rs = statement.executeQuery(SQLQuery);
						
				if (rs != null)
				{
					while(rs.next())
					{
						Level l = new DynamicLevel (rs.getInt("LJLEVEL"),rs.getString("LCODE"),rs.getInt("LSYSLOGEQUIV"));
				        Integer levelint = new Integer(rs.getInt("LSYSLOGEQUIV"));
							
				        htLevels.put(levelint, l);
					}
				}
					
				// close the connection
				jdbc_conn.close();		
			}
			catch (SQLException SQLe) {
				logger.fatal("SQL error : " + SQLe);
			}
			catch (Exception e) {
				logger.fatal("JDBC connection error");
			}
		}
			
		return htLevels;
	}
	
}
