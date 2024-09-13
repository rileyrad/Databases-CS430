import java.sql.*;

import java.io.File;
import java.io.FileWriter;
import java.util.List;
import java.util.ArrayList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class Lab9 {

	public ArrayList<ArrayList<String>> readXML(String fileName) {
		ArrayList<ArrayList<String>> data = new ArrayList<ArrayList<String>>();

    	try {
			File file = new File(fileName);
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			Document doc = db.parse(file);
			doc.getDocumentElement().normalize();
			NodeList nodeLst = doc.getElementsByTagName("Borrowed_by");

			for (int s = 0; s < nodeLst.getLength(); s++) {

				Node fstNode = nodeLst.item(s);

				if (fstNode.getNodeType() == Node.ELEMENT_NODE) {

					data.add(new ArrayList<String>());

					Element sectionNode = (Element) fstNode;
					
					NodeList memberIdElementList = sectionNode.getElementsByTagName("MemberID");
					Element memberIdElmnt = (Element) memberIdElementList.item(0);
					NodeList memberIdNodeList = memberIdElmnt.getChildNodes();

					NodeList secnoElementList = sectionNode.getElementsByTagName("ISBN");
					Element secnoElmnt = (Element) secnoElementList.item(0);
					NodeList secno = secnoElmnt.getChildNodes();

					NodeList libElementList = sectionNode.getElementsByTagName("Library");
					Element libElmnt = (Element) libElementList.item(0);
					NodeList lib = libElmnt.getChildNodes();

					NodeList codateElementList = sectionNode.getElementsByTagName("Checkout_date");
					Element codElmnt = (Element) codateElementList.item(0);
					NodeList cod = codElmnt.getChildNodes();

					NodeList cidateElementList = sectionNode.getElementsByTagName("Checkin_date");
					Element cidElmnt = (Element) cidateElementList.item(0);
					NodeList cid = cidElmnt.getChildNodes();

					data.get(s).add(0, ((Node) memberIdNodeList.item(0)).getNodeValue().trim());
					data.get(s).add(1, ((Node) secno.item(0)).getNodeValue().trim());
					data.get(s).add(2, ((Node) lib.item(0)).getNodeValue().trim());
					data.get(s).add(3, ((Node) cod.item(0)).getNodeValue().trim());
					data.get(s).add(4, ((Node) cid.item(0)).getNodeValue().trim());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return data;
	}

	public static void main(String args[]) {

		Connection con = null;

		try {
			FileWriter fwriter = new FileWriter("java_output.txt");

			Class.forName("com.mysql.cj.jdbc.Driver");
			String url = "jdbc:mysql://faure/rileyr3";
			con = DriverManager.getConnection(url, "rileyr3", "835502179");

			fwriter.write("URL: " + url + "\n");
      		fwriter.write("Connection: " + con + "\n\n");

			Lab9 inst = new Lab9();
			ArrayList<ArrayList<String>> data = inst.readXML("Libdata.xml");

			for (int i = 0; i < data.size(); i++) {
				if (!data.get(i).get(3).equals("N/A")) {
					String query = "SELECT free_copies FROM located_at WHERE ISBN = ? AND library_name = ?";
					PreparedStatement pstmt = con.prepareStatement(query);

					pstmt.setString(1, data.get(i).get(1));
					pstmt.setString(2, data.get(i).get(2));

					ResultSet rs = pstmt.executeQuery();
					if (rs.next()) {
						int freeCopies = rs.getInt("free_copies");

						if (freeCopies > 0) {
							String update = "INSERT INTO borrowed_by VALUES (?, ?, ?, ?)";
							PreparedStatement updateStmt = con.prepareStatement(update);

							updateStmt.setString(1, data.get(i).get(0));
							updateStmt.setString(2, data.get(i).get(1));
							updateStmt.setString(3, data.get(i).get(3));
							updateStmt.setString(4, null);

							updateStmt.executeUpdate();

							fwriter.write("ADDED RECORD: Book " + data.get(i).get(1) + " was checked out by " + data.get(i).get(0) + " on " + data.get(i).get(3) + ".\n");
							updateStmt.close();
						} else {
							fwriter.write("ERROR: Book " + data.get(i).get(1) + " does not have any free copies in library " + data.get(i).get(2) + ".\n");
						}
					} else {
						fwriter.write("ERROR: Book " + data.get(i).get(1) + " does not exist in library " + data.get(i).get(2) + ".\n");
					}
					
					rs.close();
					pstmt.close();
				} else {
					String query = "SELECT * FROM located_at WHERE ISBN = ? AND library_name = ?";
					PreparedStatement pstmt = con.prepareStatement(query);

					pstmt.setString(1, data.get(i).get(1));
					pstmt.setString(2, data.get(i).get(2));

					ResultSet rs = pstmt.executeQuery();
					if (rs.next()) {
						String findRecordQuery = "UPDATE borrowed_by SET checkin_date = ? WHERE member_id = ? AND ISBN = ? AND checkin_date IS NULL";
						PreparedStatement recordStmt = con.prepareStatement(findRecordQuery);

						recordStmt.setString(1, data.get(i).get(4));
						recordStmt.setInt(2, Integer.parseInt(data.get(i).get(0)));
						recordStmt.setString(3, data.get(i).get(1));

						try {
							recordStmt.executeUpdate();
							fwriter.write("UPDATED RECORD: Book " + data.get(i).get(1) + " was checked in by " + data.get(i).get(0) + " on " + data.get(i).get(4) + ".\n");
						} catch(Exception e) {
							fwriter.write("ERROR: No valid checkout record for member " + data.get(i).get(0) + " and book " + data.get(i).get(1) + ".\n");
						}
						
						recordStmt.close();
					} else {
						fwriter.write("ERROR: Book " + data.get(i).get(1) + " does not exist in library " + data.get(i).get(2) + ".\n");
					}
					
					rs.close();
					pstmt.close();
				}
			}

			con.close();
			fwriter.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}