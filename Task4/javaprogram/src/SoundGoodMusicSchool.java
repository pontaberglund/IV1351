import java.sql.Connection;
import java.util.Scanner;

public class SoundGoodMusicSchool {
    public static void main(String[] args) {
        DbFunctions db = new DbFunctions();
        Connection conn = db.connect_to_database("newsgms", "postgres", "password");
        Scanner sc = new Scanner(System.in);
        boolean run = true;
        while(run) {
            System.out.println("1. List instruments");
            System.out.println("2. Rent instrument");
            System.out.println("3. List students with rentals");
            System.out.println("4. Terminate rental");
            System.out.println("5. List terminated rentals");
            System.out.println("6. Quit");
            System.out.println();
            String option = sc.next();
            switch (option) {
                case "1" -> {
                    System.out.println("Specify which instrument (Guitar, Harp, Viola ...) or all");
                    String choice = sc.next();
                    if(choice.equals("all"))
                        db.ReadInstrumentsInStock(conn);
                    else
                        db.ReadSpecificInstrumentInStock(conn, choice);
                    System.out.println();
                }
                case "2" -> {
                    db.ReadInstrumentsInStock(conn);
                    System.out.println("Which instrument would you like to rent?");
                    System.out.println("Insert instrument id and student id and home delivery(1/0):");
                    String instrumentID = sc.next();
                    String studentID = sc.next();
                    String homeDelivery = sc.next();
                    if(db.ReadAmountOfRentals(conn, studentID) < 2)
                        db.CreateNewRental(conn, studentID, instrumentID, homeDelivery);
                    else
                        System.out.println("No! To many rentals on this student");
                    System.out.println();
                }
                case "3" -> {
                    db.ReadStudentAndRentals(conn);
                    System.out.println();
                }
                case "4" -> {
                    System.out.println("Select student id");
                    String sid = sc.next();
                    db.UpdateTerminatedRental(conn, sid);
                }
                case "5" -> {
                    db.ReadTerminatedRentals(conn);
                    System.out.println();
                }
                case "6" -> {
                    run = false;
                    System.out.println();
                }
            }
        }
    }
}


//TODO Add option to list specific instruments in stock, for example guitar
//TODO Need for SELECT FOR UPDATE ????