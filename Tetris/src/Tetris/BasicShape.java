package Tetris;
import java.awt.*;
import javax.swing.*;

//********************************************************
//   The basic class for all seven shapes
//********************************************************
public abstract class BasicShape {
	protected Color color; //the color of the shape
	protected int rotateNum; //the rotating times
	protected int position[][] = new int[4][2]; //every shape is made of four square; 
											  //[2] labels the x, y position
	protected int xPos, yPos; //the starting point for each shape (the middle of the first line)
	
	//----------------------------------------------------
	//	Constructor: set the default rotation
	//----------------------------------------------------
	public BasicShape(){
		xPos = 150;
		yPos = 0;
		rotateNum = (int)(Math.random()*4);
		/*
		switch(rotateNum)
		{
		case 0: zeroRotate();
			break;
		case 1: firstRotate();
			break;
		case 2: secondRotate();
			break;
		case 3: thirdRotate();
			break;
		}*/
	}
	
	//----------------------------------------------------
	//	Count the clockwise rotating time
	//----------------------------------------------------
	public void rotate(){
		rotateNum++;
		if(rotateNum == 4) 
			rotateNum = 0;
	}
	
	//----------------------------------------------------
	//	Count the contra-clockwise rotating time
	//----------------------------------------------------
	public void contraRotate(){
		rotateNum--;
		if(rotateNum < 0)
			rotateNum +=4;
	}
	
	//----------------------------------------------------
	//	Set the place of the shape and the starting place
	//----------------------------------------------------
	public void setPlace(int x, int y){
		xPos = x;
		yPos = y;
		switch(rotateNum)
		{
			case 0: zeroRotate();
				break;
			case 1: firstRotate();
				break;
			case 2: secondRotate();
				break;
			case 3: thirdRotate();
				break;
		}
	}
	
	//----------------------------------------------------
	//	Draw the graphics of the shape
	//----------------------------------------------------
	public void drawShape(Graphics g){
		
		for(int i = 0; i < 4; i++){
			g.setColor(color);
			g.fillRect(position[i][0], position[i][1], 30, 30);
			g.setColor(Color.black);
			g.drawRect(position[i][0], position[i][1], 30, 30);
		}
	}
	
	//----------------------------------------------------
	//	Get the rightmost position of the shape
	//----------------------------------------------------
	public int getRight(){
		int rightMost = position[0][0];
		for ( int i = 1; i < 4; i++){
			if(position[i][0] > rightMost)
				rightMost = position[i][0];
		}
		return (rightMost + 30);
	}
	
	//----------------------------------------------------
	//	Get the leftmost position of the shape
	//----------------------------------------------------
	public int getLeft(){
		int leftMost = position[0][0];
		for ( int i = 1; i < 4; i++){
			if(position[i][0] < leftMost)
				leftMost = position[i][0];
		}
		return leftMost;
	}
	
	//----------------------------------------------------
	//	Get the bottom position of the shape
	//----------------------------------------------------
	public int getBottom(){
		int bottom = position[0][1];
		for ( int i = 1; i < 4; i++){
			if(position[i][1] > bottom)
				bottom = position[i][1];
		}
		
		return (bottom + 30) ;
	}	
	
	//----------------------------------------------------
	//	Get the top position of the shape
	//----------------------------------------------------
	public int getTop(){
		int top = position[0][1];
		for ( int i = 1; i < 4; i++){
			if(position[i][1] < top)
				top = position[i][1];
		}
		
		return top ;
	}	
	
	//---------------------------------------------------
	// 	Get the four squares' positions (xPos, yPos)
	//---------------------------------------------------
	public int[] getFirstPlace(){
		int pos[] = new int[2];
		pos[0] = (position[0][0] - 60) / 30;
		pos[1] = (position[0][1] - 60) / 30;
		return pos;
	}
	public int[] getSecondPlace(){
		int pos[] = new int[2];
		pos[0] = (position[1][0] - 60) / 30;
		pos[1] = (position[1][1] - 60) / 30;
		return pos;
	}
	public int[] getThirdPlace(){
		int pos[] = new int[2];
		pos[0] = (position[2][0] - 60) / 30;
		pos[1] = (position[2][1] - 60) / 30;
		return pos;
	}
	public int[] getFourthPlace(){
		int pos[] = new int[2];
		pos[0] = (position[3][0] - 60) / 30;
		pos[1] = (position[3][1] - 60) / 30;
		return pos;
	}
	
	//----------------------------------------------------
	//	rotateNum = 0, the place of the shape
	//----------------------------------------------------
	public abstract void zeroRotate();
	//----------------------------------------------------
	//	rotateNum = 1, the place of the shape
	//----------------------------------------------------
	public abstract void firstRotate();
	//----------------------------------------------------
	//	rotateNum = 2, the place of the shape
	//----------------------------------------------------
	public abstract void secondRotate();
	//----------------------------------------------------
	//	rotateNum = 3, the place of the shape
	//----------------------------------------------------
	public abstract void thirdRotate();
}
