package Team4;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
/**
 * @author Dac Vu Ho
 */
public class GroupProject {

	public static void main(String args[]) throws SQLException,  ClassNotFoundException {

		// Load the MySQL driver
		Class.forName("com.mysql.cj.jdbc.Driver");

		// Connect to the database
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/groupproject","root","hodacvu3");

		// For atomicity
		conn.setAutoCommit(false);
		
		// For isolation 
		conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE); 
		
		Statement stmt1 = null;
		try {
			// create statement object
			stmt1 = conn.createStatement();
			
			// Either the 2 following inserts are executed, or none of them are. This is atomicity.
			//The depot d1 changes its name to dd1 in Depot 
			stmt1.executeUpdate("UPDATE `groupproject`.`depot` SET `dep` = 'dd1' WHERE (`dep` = 'd1')");
			//The depot d1 changes its name to dd1 in Stock
			stmt1.executeUpdate("UPDATE `groupproject`.`stock` SET `dep` = 'dd1' WHERE (`dep` = 'd1')");
		} catch (SQLException e) {
			System.out.println("catch Exception");
			// For atomicity
			conn.rollback();
			stmt1.close();
			conn.close();
			return;
		} // main
		conn.commit();
		stmt1.close();
		conn.close();
	}
}