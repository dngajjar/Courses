package Tetris;

import java.awt.*;
//import java.awt.event.*;
import javax.swing.*;

public class Game{
	public static void main(String[] args){
		JFrame frame = new JFrame("Enjoy Your Tetris!");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		ScreenPanel panel = new ScreenPanel();
		frame.getContentPane().add(panel, "Center");
		frame.pack();
		frame.setVisible(true);
	}


}

