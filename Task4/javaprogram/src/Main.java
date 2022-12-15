import java.sql.Connection;

public class Main {
    public static void main(String[] args) {
        DbFunctions db = new DbFunctions();
        Connection conn = db.connect_to_database("newsgms", "postgres", "password");
        //db.listInstrumentsInStock(conn);
        db.ReadSpecificInstrumentsInStock(conn, "Guitar");
    }
}
