package Tetris;
import java.awt.*;
import javax.swing.*;

public class OShape extends BasicShape {
	private Color oColor = new Color(255, 255, 0);
	
	//----------------------------------------------------
	//	Constructor: set the color of the T-shape
	//----------------------------------------------------
	public OShape(){
		color = oColor;
	}
	
	//----------------------------------------------------
	//	Define the zero type of T-shape (rotateNum = 0)
	//----------------------------------------------------
	public void zeroRotate(){
		position[0][0] = xPos - 30;
		position[0][1] = yPos;
		position[1][0] = xPos;
		position[1][1] = yPos;
		position[2][0] = xPos - 30;
		position[2][1] = yPos + 30;
		position[3][0] = xPos;
		position[3][1] = yPos + 30;	
	}
	
	//----------------------------------------------------
	//	Define the first type of T-shape (rotateNum = 1)
	//----------------------------------------------------
	public void firstRotate(){
		position[0][0] = xPos - 30;
		position[0][1] = yPos;
		position[1][0] = xPos;
		position[1][1] = yPos;
		position[2][0] = xPos - 30;
		position[2][1] = yPos + 30;
		position[3][0] = xPos;
		position[3][1] = yPos + 30;	
	}
	
	//----------------------------------------------------
	//	Define the  second of T-shape (rotateNum = 2)
	//----------------------------------------------------
	public void secondRotate(){
		position[0][0] = xPos - 30;
		position[0][1] = yPos;
		position[1][0] = xPos;
		position[1][1] = yPos;
		position[2][0] = xPos - 30;
		position[2][1] = yPos + 30;
		position[3][0] = xPos;
		position[3][1] = yPos + 30;	
	}
	
	//----------------------------------------------------
	//	Define the third type of T-shape (rotateNum = 3)
	//----------------------------------------------------
	public void thirdRotate(){
		position[0][0] = xPos - 30;
		position[0][1] = yPos;
		position[1][0] = xPos;
		position[1][1] = yPos;
		position[2][0] = xPos - 30;
		position[2][1] = yPos + 30;
		position[3][0] = xPos;
		position[3][1] = yPos + 30;	
	}
}
