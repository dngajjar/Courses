package Tetris;
import java.awt.*;
import javax.swing.*;

public class JShape extends BasicShape{
	private Color jColor = new Color(0, 0, 255);
	
	//----------------------------------------------------
	//	Constructor: set the color of the T-shape
	//----------------------------------------------------
	public JShape(){
		color = jColor;
	}
	
	//----------------------------------------------------
	//	Define the zero type of T-shape (rotateNum = 0)
	//----------------------------------------------------
	public void zeroRotate(){
		position[0][0] = xPos;
		position[0][1] = yPos + 30;
		for(int i = 1; i < 4; i++){
			position[i][0] = xPos + (i - 3) * 30;
			position[i][1] = yPos;
		}	
	}
	
	//----------------------------------------------------
	//	Define the first type of T-shape (rotateNum = 1)
	//----------------------------------------------------
	public void firstRotate(){
		position[0][0] = xPos - 30;
		position[0][1] = yPos + 60;
		for(int i = 1; i < 4; i++){
			position[i][0] = xPos;
			position[i][1] = yPos + (i - 1) * 30;
		}
	}
	
	//----------------------------------------------------
	//	Define the  second of T-shape (rotateNum = 2)
	//----------------------------------------------------
	public void secondRotate(){
		position[0][0] = xPos - 60;
		position[0][1] = yPos;
		for(int i = 1; i < 4; i++){
			position[i][0] = xPos + (i - 3) * 30;
			position[i][1] = yPos + 30;
		}
	}
	
	//----------------------------------------------------
	//	Define the third type of T-shape (rotateNum = 3)
	//----------------------------------------------------
	public void thirdRotate(){
		position[0][0] = xPos;
		position[0][1] = yPos;
		for(int i = 1; i < 4; i++){
			position[i][0] = xPos - 30;
			position[i][1] = yPos + (i - 1) * 30;
		}
	}
}
