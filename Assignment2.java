import java.sql.*;
import java.util.List;

// If you are looking for Java data structures, these are highly useful.
// Remember that an important part of your mark is for doing as much in SQL (not Java) as you can.
// Solutions that use only or mostly Java will not receive a high mark.
//import java.util.ArrayList;
//import java.util.Map;
//import java.util.HashMap;
//import java.util.Set;
//import java.util.HashSet;
public class Assignment2 extends JDBCSubmission {
    Connection conn;

    public Assignment2() throws ClassNotFoundException {

        Class.forName("org.postgresql.Driver");
    }

    @Override
    public boolean connectDB(String url, String username, String password) {
        // Implement this method!
        try
        {
            conn = DriverManager.getConnection(url, username, password);
        }
        catch (SQLException e)
        {
            // do something appropriate with the exception, *at least*:
            e.printStackTrace();
        }

        return true;
    }

    @Override
    public boolean disconnectDB() {
        // Implement this method!
        try
        {
            conn.close();
        }
        catch (SQLException e)
        {
            // do something appropriate with the exception, *at least*:
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public ElectionCabinetResult electionSequence(String countryName) {
        // Implement this method!
        try
        {
            PreparedStatement stmt = conn.prepareStatement("SELECT e.* FROM election e");
            ResultSet countryElections = stmt.executeQuery();
            while (countryElections.next()) {
              int id = countryElections.getInt(1);
              /* If the tuple also had a float and another int
              attribute, you’d get them by calling
              worths.getFloat(2) and worths.getInt(3).
              Or you can look up values by attribute name.
              Example: worths.getInt(netWorth)
              */
              System.out.println(id);
            }
        }
        catch (SQLException e)
        {
            // do something appropriate with the exception, *at least*:
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Integer> findSimilarPoliticians(Integer politicianName, Float threshold) {
        // Implement this method!
        return null;
    }

    public static void main(String[] args) {
        // args[0] - local database, i.e. 'postgres?currentSchema=parlgov'
        // args[1] - username
        // args[2] - password
        // args[3] - countryName
        // You can put testing code in here. It will not affect our autotester.
        // System.out.println("Hello");

        String database = args[0];
        String username = args[1];
        String password = args[2];
        String countryName = args[3];

        try
        {
            Assignment2 myA2 = new Assignment2();
            String url = "jdbc:postgresql://localhost:5432/"+database;
            myA2.connectDB(url, username, password);
            myA2.electionSequence(countryName);
            myA2.disconnectDB();
        }
        catch (ClassNotFoundException e)
        {
            // do something appropriate with the exception, *at least*:
            e.printStackTrace();
        }

    }

}
