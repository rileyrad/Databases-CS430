import javax.swing.JOptionPane;

public class Lab4B_ex
{
    public static void main (String[] args)
    {
	String value;

	System.out.println("Asking for value");

	// Get the value
	value = JOptionPane.showInputDialog ("Enter a value:");

	System.out.println("Got value:  " + value);

	// Display results
	JOptionPane.showMessageDialog (null,
		"You entered:  " + value);

	return;
    }

} // end 