import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Scanner;

public class DbFunctions {

    public Connection connect_to_database(String dbName, String username, String password) {
        Connection conn = null;
        try {
            Class.forName("org.postgresql.Driver");
            conn= DriverManager.getConnection("jdbc:postgresql://localhost:5432/"+dbName, username, password);
            if(conn!=null) {
                System.out.println("Connection success");
                conn.setAutoCommit(false);
            }
            else
                System.out.println("Connection failed");
        }catch (Exception e) {
            System.out.println(e);
        }
        return conn;
    }

    public void ReadInstrumentsInStock(Connection conn) {
        Statement statement;
        ResultSet result = null;
        try {
            String query = "select * FROM list_instrument_in_stock";
            statement = conn.createStatement();
            result = statement.executeQuery(query);
            while(result.next()) {
                System.out.print("id: " + result.getString("id") + " ");
                System.out.print("brand: " + result.getString("brand") + " ");
                System.out.print("instrument: " + result.getString("instrument") + " ");
                System.out.print("price: " + result.getString("price") + " ");
                System.out.println();
            }
            conn.commit();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public void ReadSpecificInstrumentInStock(Connection conn, String instrument) {
        Statement statement;
        ResultSet result = null;
        try {
            String query = String.format("select * from list_instrument_in_stock where instrument='%s'", instrument);
            statement = conn.createStatement();
            result = statement.executeQuery(query);
            while(result.next()) {
                System.out.print("id: " + result.getString("id") + " ");
                System.out.print("brand: " + result.getString("brand") + " ");
                System.out.print("instrument: " + result.getString("instrument") + " ");
                System.out.print("price: " + result.getString("price") + " ");
                System.out.println();
            }
            conn.commit();
        } catch (Exception e) {
            System.out.println(e);
        }

    }

    public void ReadSpecificInstrumentsInStock(Connection conn, String instrument) {
        Statement statement;
        ResultSet result = null;
        try {
            String query = String.format("select * FROM list_instrument_in_stock WHERE instrument='%s'", instrument);
            statement = conn.createStatement();
            result = statement.executeQuery(query);
            while(result.next()) {
                System.out.print("id: " + result.getString("id") + " ");
                System.out.print("brand: " + result.getString("brand") + " ");
                System.out.print("instrument: " + result.getString("instrument") + " ");
                System.out.print("price: " + result.getString("price") + " ");
                System.out.println();
            }
            conn.commit();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public void CreateNewRental(Connection conn, String studentID, String instrumentID, String homeDelivery) {
        Statement statement;
        try {
            //Add the rental
            String query1 = String.format("insert into rental(student_id, home_delivery, start_date, end_date)" +
                    " values ('%s', '%s', current_date, current_date + INTERVAL '12 month')", studentID, homeDelivery);
            statement = conn.createStatement();
            int updatedRows = statement.executeUpdate(query1);
            if(updatedRows != 1) {
                conn.rollback();
                System.out.println("Something went wrong with the update on query 1");
                return;
            }

            //Get the latest rental id that was just added
            String query2 = "select rental_id from rental order by rental.rental_id desc limit 1";
            ResultSet rs = statement.executeQuery(query2);
            String latestRental = null;
            if(rs.next())
                latestRental = rs.getString("rental_id");
            //Connect the rental to wanted instrument
            String query3 = String.format("update instrument_in_stock set rental_id=%s where instrument_in_stock_id=%s", latestRental, instrumentID);
            //Update the row
            updatedRows = statement.executeUpdate(query3);
            if(updatedRows != 1) {
                conn.rollback();
                System.out.println("Something went wrong with the update on query 4");
                return;
            }
            conn.commit();
            System.out.println("Success!");
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public void ReadStudentAndRentals(Connection conn) {
        Statement statement;
        try {
            String query = "select * from list_student_and_rentals";
            statement = conn.createStatement();
            ResultSet result = statement.executeQuery(query);
            while(result.next()) {
                System.out.println("Student id: " + result.getString("student_id"));
                System.out.println("Name: " + result.getString("first_name") + " " + result.getString("last_name"));
                System.out.println("Rental id: " + result.getString("rental_id"));
                System.out.println("Instrument: " + result.getString("instrument"));
                System.out.println("Brand: " + result.getString("brand"));
                System.out.println("Date: " + result.getString("start_date") + " to " + result.getString("end_date"));
                System.out.println("Home delivery: " + result.getString("home_delivery"));
                System.out.println();
            }
            conn.commit();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public int ReadAmountOfRentals(Connection conn, String student_id) {
        int r = 0;
        Statement statement;
        try{
            String query = String.format("select count(*) from rental where student_id=%s group by student_id ", student_id);
            statement = conn.createStatement();
            ResultSet result = statement.executeQuery(query);
            if(result.next())
                r = Integer.parseInt(result.getString("count"));
            conn.commit();
        } catch (Exception e) {
            System.out.println(e);
        }
        return r;
    }

    public void UpdateTerminatedRental(Connection conn, String student_id) {
        Statement statement;
        Scanner sc = new Scanner(System.in);
        int updatedRows;
        try {
            String query = String.format("select * from list_student_and_rentals where student_id=%s", student_id);
            statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(query);
            while(rs.next()) {
                System.out.println("Rental id: " + rs.getString("rental_id"));
                System.out.println("Instrument: " + rs.getString("instrument"));
                System.out.println();
            }
            System.out.println("Choose rental id");
            String rid = sc.next();
            //Get price of instrument
            String price_of_instrument = null;
            String query2 = String.format("select price from instrument_in_stock where rental_id=%s", rid);
            ResultSet price = statement.executeQuery(query2);
            if(price.next())
                price_of_instrument = price.getString("price");
            //Update instrument_in_stock
            String query3 = String.format("update instrument_in_stock set rental_id=null where rental_id=%s", rid);
            updatedRows = statement.executeUpdate(query3);
            if(updatedRows != 1) {
                conn.rollback();
                System.out.println("Something went wrong with the update on query 3");
                return;
            }
            //Update rental
            String query6 = String.format("update rental set end_date=current_date, terminated_price=%s where rental_id=%s", price_of_instrument, rid);
            updatedRows = statement.executeUpdate(query6);
            if(updatedRows != 1) {
                conn.rollback();
                System.out.println("Something went wrong with the update on query 6");
                return;
            }
            conn.commit();
            System.out.println("Success!");
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public void ReadTerminatedRentals(Connection conn) {
        Statement statement;
        try {
            String query = "select * from list_terminated_rentals";
            statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(query);
            while(rs.next()) {
                System.out.println("Student id: " + rs.getString("student_id"));
                System.out.println("Name: " + rs.getString("first_name") + " " + rs.getString("last_name"));
                System.out.println("Rental id: " + rs.getString("rental_id"));
                System.out.println("Date: " + rs.getString("start_date") + " - " + rs.getString("end_date"));
                System.out.println("Price: " + rs.getString("terminated_price"));
                System.out.println();
            }
            conn.commit();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

}