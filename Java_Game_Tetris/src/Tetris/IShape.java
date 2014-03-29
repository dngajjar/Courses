package Tetris;
import java.awt.*;
import javax.swing.*;

public class IShape extends BasicShape {
	private Color Icolor = new Color(0, 255, 255);
	
	//----------------------------------------------------
		//	Constructor: set the color of the T-shape
		//----------------------------------------------------
		public IShape(){
			color = Icolor;
		}
		
		//----------------------------------------------------
		//	Define the zero type of T-shape (rotateNum = 0)
		//----------------------------------------------------
		public void zeroRotate(){
			for(int i = 0; i < 4; i++){
				position[i][0] = xPos;
				position[i][1] = yPos + i * 30;
			}	
		}
		
		//----------------------------------------------------
		//	Define the first type of T-shape (rotateNum = 1)
		//----------------------------------------------------
		public void firstRotate(){
			for(int i = 0; i < 4; i++){
				position[i][0] = xPos + (i - 2) * 30;
				position[i][1] = yPos;
			}
		}
		
		//----------------------------------------------------
		//	Define the  second of T-shape (rotateNum = 2)
		//----------------------------------------------------
		public void secondRotate(){
			for(int i = 0; i < 4; i++){
				position[i][0] = xPos;
				position[i][1] = yPos + i * 30;
			}
		}
		
		//----------------------------------------------------
		//	Define the third type of T-shape (rotateNum = 3)
		//----------------------------------------------------
		public void thirdRotate(){
			for(int i = 0; i < 4; i++){
				position[i][0] = xPos + (i - 2) * 30;
				position[i][1] = yPos;
			}
		}
}
