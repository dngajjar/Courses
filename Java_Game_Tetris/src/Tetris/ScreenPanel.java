package Tetris;
import java.awt.*;
import java.awt.event.*;
import java.awt.image.*;
import java.io.FileInputStream;

import javax.imageio.ImageIO;
import javax.swing.*;

public class ScreenPanel extends JPanel implements Runnable, KeyListener, ActionListener{
	//-------------------------------------------------
	// Define the objects and variables
	//-------------------------------------------------
	//String imgPath = "C://Java Source//book//Square//bg.jpg";  
	

	private BufferedImage bufferedImage;
	private Image buffer;
	private Graphics2D page;
	private ImageIcon bg = new ImageIcon("bg.jpg"); //background image
	
	private int time; //the falling time interval
	private final int TIME_EASY = 500;
	private final int TIME_DIFFICULT = 300;
	private final int TIME_HELL = 100;
	private final int TIME_INFERNO = 50;
	private int gameType;
	
	BasicShape currShape; //the current shape 
	BasicShape nextShape; //the next shape
	private int xPos,yPos; //the x, y position for the current shape
	private final int xEx = 500, yEx = 130; //the position for showing the next shape
	
	private int rowNum, scores; //the total eliminating row number and the total scores
	
	private final int BASE_SCORE = 100; //the basic score for eliminating a row
	
	private JButton bLeft, bRight, bChange, bDown, bPause, bContinue, bNew; //Controlling buttons
	private JLabel label1, label2, label3, label4, label5, label6;  
	private ButtonGroup myButtonGroup;
	private JRadioButton easyButton, difficultButton, hellButton, infernoButton;
	
	private Thread th; //control the falling action
	
	private boolean next; //indicating whether the next shape should be released
	private boolean stop; //indicating whether the pause button is pushed
	private boolean over; //indicating whether the game is over
	
	private Font font = new Font("Calibri", Font.BOLD, 25); //define the font for the labels in the main screen
	private int counter;  //control the time drawing the first shape
	private boolean filled[][] = new boolean[10][20]; //labeling whether the place is empty
	private int topRow; //labeling the top line of the filled 
	//--------------------------------------------------
	// Constructor
	//--------------------------------------------------
	public ScreenPanel(){
		setLayout(null);
		//set the initial background
		
		bufferedImage = new BufferedImage(bg.getIconHeight(),bg.getIconWidth(),BufferedImage.TYPE_INT_RGB);
		page = (Graphics2D) bufferedImage.getGraphics();
		page.drawImage(bg.getImage(), 0, 0,bg.getImageObserver());
		page.setColor(new Color(128, 128, 0));
		page.fillRect(50, 50, 320, 620);
		page.setColor(new Color(0, 0, 0));
		page.fillRect(60, 60, 300, 600);
		
		
		//set all the squares (200) empty
		for(int i = 0; i < 10; i++){
			for(int j =  0; j < 20; j++){
				filled[i][j] = false;
			}
		}
		
		//set the shape falling controlling property
		th = new Thread(this);
		this.time = TIME_EASY;
		gameType = 1;
		counter = 0;
		
		
		next = false; //the next shape is not falling
		//going = false; //the shape is not falling
		stop = false; //the pause button is not pushed
		over = true; //the game is not over
		
		//the initial eliminating row number and total scores
		rowNum = 0;
		scores = 0;
		
		
		//	Set the basic layout of the interface
		myButtonGroup = new ButtonGroup();
		easyButton = new JRadioButton("Easy", true);
		difficultButton = new JRadioButton("Difficult");
		hellButton = new JRadioButton("Hell");
		infernoButton = new JRadioButton("Inferno");
		
		easyButton.setBounds(400, 300, 80, 20);
		difficultButton.setBounds(500, 300, 80, 20);
		hellButton.setBounds(400, 350, 80, 20);
		infernoButton.setBounds(500, 350, 80, 20);
		
		myButtonGroup.add(easyButton);
		myButtonGroup.add(difficultButton);
		myButtonGroup.add(hellButton);
		myButtonGroup.add(infernoButton);
		
		bLeft = new JButton("<");
		bRight = new JButton(">");
		bChange = new JButton("Change");
		bDown = new JButton("Down");
		bContinue = new JButton("Continue");
		bPause = new JButton("Pause");
		bNew = new JButton("New Game");
		
		bLeft.setBounds(400, 400, 80, 40);
		bRight.setBounds(500, 400, 80, 40);
		bChange.setBounds(400, 450, 80, 40);
		bDown.setBounds(500, 450, 80, 40);
		bPause.setBounds(400, 500, 80, 40);
		bContinue.setBounds(500, 500, 80, 40);
		bNew.setBounds(450, 550, 100, 40);
		
		label1 = new JLabel("The Highest Scores: ");
		label2 = new JLabel("---");
		label3 = new JLabel("Your Scores: ");
		label4 = new JLabel("---");
		label5 = new JLabel();
		label6 = new JLabel("Difficulty:");
		
		label3.setBounds(400, 50, 150, 50);
		label3.setFont(font);
		label4.setBounds(550, 50, 200, 50);
		label4.setForeground(Color.pink);
		label4.setFont(font);
		label5.setFont(font);
		label5.setForeground(Color.red);
		label5.setBounds(150, 100, 200, 50);
		label6.setFont(font);
		label6.setForeground(Color.black);
		label6.setBounds(400, 250, 200, 50);

		
		add(label3);
		add(label4);
		add(label5);
		add(label6);
		add(bLeft);
		add(bRight);
		add(bChange);
		add(bDown);
		add(bContinue);
		add(bPause);
		add(bNew);
		
		add(easyButton);
		add(difficultButton);
		add(hellButton);
		add(infernoButton);
		//add(myButtonGroup);
		//-----------------------------------------------------
		//  Add actionlisteners to these buttons and the keyboard
		//------------------------------------------------------
		addKeyListener(this);
		setFocusable(true);
		
		//bContinue.addMouseListener(new StartMouseAdapter());
		bLeft.addActionListener(this);
		bRight.addActionListener(this);
		bChange.addActionListener(this);
		bDown.addActionListener(this);
		bContinue.addActionListener(this);
		bPause.addActionListener(this);
		bNew.addActionListener(this);
		easyButton.addActionListener(new RadioButton());
		difficultButton.addActionListener(new RadioButton());
		hellButton.addActionListener(new RadioButton());
		infernoButton.addActionListener(new RadioButton());
		
		currShape = initShape();
		nextShape = initShape();
		
		setPosition(210, 60);
		
		currShape.setPlace(xPos, yPos);
		
		setBackground(Color.black);
		setPreferredSize(new Dimension(700, 700));
		
		
	}
	
	//-----------------------------------------------------
	//	Set the x, y position for the shap
	//----------------------------------------------------
	public void setPosition(int x, int y){
		xPos = x;
		yPos = y;
	}
	
	private void setFont(String string, int bold, int i) {
		// TODO Auto-generated method stub
		
	}
	
	//-----------------------------------------------------
	//	The initial of the shapes
	//----------------------------------------------------
	public BasicShape initShape( ){
		BasicShape shape = new IShape();
		int factor = (int)(Math.random() * 7);
		
		switch(factor){
		case 0: shape = new IShape();
			break;
		case 1: shape = new JShape();
			break;
		case 2: shape = new LShape();
			break;
		case 3: shape = new OShape();
			break;
		case 4: shape = new SShape();
			break;
		case 5: shape = new TShape();
			break;
		case 6: shape = new ZShape();
			break;
		}
		return shape;
	}


	
	//-----------------------------------------------------
	//	Set the background of panel
	//----------------------------------------------------
	public void paintComponent(Graphics page){
		super.paintComponent(page);
		
		page.drawImage(bufferedImage,0,0,null);
		if(counter > 0){
			 if(counter == 1)
				yPos -= 30;
			currShape.setPlace(xPos, yPos);
			if(!isFilled())
			{
				currShape.drawShape(page);
			}
			else if(isFilled() && currShape.getTop() == 60){
				//test whether the game is over
				
					stop = true;
					over = true;
					
					synchronized(this)
					{
						notify();
					}
					repaint();
					requestFocus(true);
					page.clearRect(60, 60, 300, 600);
					page.setColor(Color.magenta);
					page.fillRect(60, 60, 300, 600);
					//page.copyArea(60, 0, 300, 60, 300, 60);
					label5.setText("Game Over.");
				
			}
			nextShape.setPlace(xEx, yEx);
			nextShape.drawShape(page);
		}
	}
	
	
	//---------------------------------------------------------
	//	Reduce the flashing
	//---------------------------------------------------------
	public void update(Graphics page)
	{
		page.clipRect(0,0,200,400);
		
		paintComponent(page);
	}
	
	//-----------------------------------------------------------
	// Judge the outline of the shapes
	//-----------------------------------------------------------
	public void judgeLine(){
		while(currShape.getTop() < 60)
		{
			yPos += 30;
			//currShape.contraRotate();
			currShape.setPlace(xPos, yPos);
		}
		while(currShape.getBottom() > 660)
		{
			yPos -= 30;
			currShape.setPlace(xPos, yPos);
		}
		while(currShape.getLeft() < 60)
		{
			xPos += 30;
			currShape.setPlace(xPos, yPos);
		}
		while(currShape.getRight() > 360)
		{
			xPos -= 30;
			currShape.setPlace(xPos, yPos);
		}

	}
	
	//-----------------------------------------------------
	//	Judge whether the rows are filled
	//----------------------------------------------------
	public void setFilled(){
		//Vector vector[] = new Vector[4]; //try c++ using vector
		int positions[][] = new int[4][2];
		int array[] = new int[2];
		positions[0] = currShape.getFirstPlace();
		positions[1] = currShape.getSecondPlace();
		positions[2] = currShape.getThirdPlace();
		positions[3] = currShape.getFourthPlace();
		filled[positions[0][0]][positions[0][1]] = true;
		filled[positions[1][0]][positions[1][1]] = true;
		filled[positions[2][0]][positions[2][1]] = true;
		filled[positions[3][0]][positions[3][1]] = true;
		next = true;
		currShape.drawShape(page);
		
		
		
		//get the order of these four square from bottom to top
		
		int tmpX, tmpY, label, n = 0, m = 4;
		for(int i = 0; i < 4; i ++){
			n = i;
			label = positions[i][1];
			for(int j = i + 1; j < 4; j ++){
			
				if( label < positions[j][1])
				{
					label = positions[j][1];
					n = j;
				}
				else if( label == positions[j][1])
				{
					positions[j][1] = -1;
				}

			}
			if(n != i)
			{
				tmpX = positions[i][0];
				tmpY = positions[i][1];
				positions[i][1] = positions[n][1];
				positions[i][0] = positions[n][0];
				positions[n][1] = tmpY;
				positions[n][0] = tmpX;
			}
			
		}
		for(int l = 0; l < 4; l++){
			if(positions[l][1] == -1)
				m--;
		}
		//System.out.println("positions[0][1]:" + positions[0][1]);
		//System.out.println("positions[1][1]:" + positions[1][1]);
		//System.out.println("positions[2][1]:" + positions[2][1]);
		//System.out.println("positions[3][1]:" + positions[3][1]);
		//test whether these four place can fill a row then eliminate the specific rows
		//System.out.println(m);
		for(int i = 0; i < m; i++){
			array[0] = positions[i][0];
			array[1] = positions[i][1];
			boolean result = isRowFull(array);
			if(result)
			{
				//repaint();
				//System.out.println("RowFull");
				//System.out.println(m);
				this.topRow = getTopRow();
				for(int k = array[1]; k >= this.topRow; k--){
					int row = k * 30 + 60;
					page.clearRect(60, row, 300, 30);
					page.copyArea(60, row - 30, 300, 30, 0, 30);
					//repaint();
				}
				
				//page.setColor(Color.black);
				//page.fillRect(60, 60, 300, 30);	
				//repaint();
				for(int j = i + 1; j < m; j++){
					positions[j][1] += 1;
				}
			}
		}
		
		//repaint();
	} 
	//-----------------------------------------------------
	//	Judge whether the location of the shape is filled
	//----------------------------------------------------
	public boolean isFilled(){
		boolean result;
		int one[] = currShape.getFirstPlace();
		int two[] = currShape.getSecondPlace();
		int three[] = currShape.getThirdPlace();
		int four[] = currShape.getFourthPlace();
		if(filled[one[0]][one[1]]||filled[two[0]][two[1]]||filled[three[0]][three[1]]||filled[four[0]][four[1]])
			result = true;
		else 
			result = false;
		return result;
	}

	
	
	
	//--------------------------------------------------------------
	//	Define the key listener
	//--------------------------------------------------------------
		public void keyReleased(KeyEvent event){
			int keyCode = event.getKeyCode();
			if((!next) && (!stop)){
				//Press the up button: change
				if(keyCode == KeyEvent.VK_UP && counter > 1)
				{
					currShape.rotate();
					currShape.setPlace(xPos, yPos);
					judgeLine();
					if(isFilled())
					{
						currShape.contraRotate();
						currShape.setPlace(xPos, yPos);
						
					}
					repaint();
				}
				//Press the down button: going down
				else if(keyCode == KeyEvent.VK_DOWN && currShape.getBottom() < 660)
				{ 
					
					yPos += 30;
					currShape.setPlace(xPos, yPos);
					//judgeLine();
					if(isFilled())
					{
						yPos -= 30;
						currShape.setPlace(xPos, yPos);
						setFilled(); //indicating the locating position is filled
						
					}
					else if(currShape.getBottom() == 660)
					{
						setFilled(); //indicating the locating position is filled
					}
					repaint();
				}
				else if(keyCode == KeyEvent.VK_LEFT && currShape.getLeft() > 60)
				{
					xPos -= 30;
					currShape.setPlace(xPos, yPos);
					//judgeLine();
					if(isFilled()){
						xPos += 30;
						currShape.setPlace(xPos, yPos);
						
					}
					repaint();
				}
				else if(keyCode == KeyEvent.VK_RIGHT && currShape.getRight() < 360)
				{
					xPos += 30;
					currShape.setPlace(xPos, yPos);
					//judgeLine();
					if(isFilled())
					{
						xPos -= 30;
						currShape.setPlace(xPos, yPos);
						
					}
					repaint();
				}
			
			}
		}	
		//-------------------------------------------------------
		//	Define the abstract methods
		//------------------------------------------------------
		public void keyPressed(KeyEvent event)
		{ 
		}
		public void keyTyped(KeyEvent event)
		{
			
		}
	//-----------------------------------------------------------
	//	Automatically going down
	//-----------------------------------------------------------
	public void run(){
		while(true)
		{	
			if(!stop && !over){
				//For the first time the first shape showing 
				counter ++;
				
				if(next){
					currShape = nextShape;
					nextShape = initShape();
					next = false;
					setPosition(210, 60); 
				}
				else if(currShape.getBottom() == 660){
					setFilled();
				}
				else{
					yPos += 30;
					currShape.setPlace(xPos, yPos);
					if(isFilled()){
						
						//judgeLine();
						yPos -= 30;
						currShape.setPlace(xPos, yPos);
						setFilled();
						
			
					}
				}
			}
			
			repaint();
			try{
				if(stop || over)
				{
					synchronized(this)
					{
						wait();
					}
				}
				Thread.sleep(this.time);
			}
			catch(InterruptedException e)
			{ 
				e.printStackTrace();
			}
		}
	}
	
	//-----------------------------------------------------------
	//	Define the  button listeners
	//-----------------------------------------------------------
	
		public void actionPerformed (ActionEvent event){
			Object btn = (JButton)event.getSource();
			//The Left Button
			if(btn == bLeft){
				if(!stop && currShape.getLeft() > 60){
					xPos -= 30;
					currShape.setPlace(xPos, yPos);
				
					if(isFilled()){
						xPos += 30;
						currShape.setPlace(xPos, yPos);
					}
					repaint();
				}
			}
			
			//The Right Button
			if(btn == bRight){
				if(!stop && currShape.getRight() < 360){
					xPos += 30;
					currShape.setPlace(xPos, yPos);
					judgeLine();
					if(isFilled()){
						xPos -= 30;
						currShape.setPlace(xPos, yPos);
					}
					repaint();
				}
			}
			
			//The Down Button
			if(btn == bDown){
				if(!stop && currShape.getBottom() < 660){
					yPos += 30;
					currShape.setPlace(xPos, yPos);
					//judgeLine();
					if(isFilled()){
						yPos -= 30;
						currShape.setPlace(xPos, yPos);
						setFilled();
					}
					else if(currShape.getBottom() == 660){
						setFilled();
					}
					repaint();
				}
			}
			
			//The Change Button
			if(btn == bChange){
				if(!stop && counter > 1){
					currShape.rotate();
					currShape.setPlace(xPos, yPos);
					judgeLine();
					if(isFilled()){
						currShape.contraRotate();
						currShape.setPlace(xPos, yPos);
					}
					repaint();
				}
			}
			
			//The Start Button
			if(btn == bContinue)
			{	
				if(!over){
					stop = false;
					synchronized(this)
					{
						notify();
					}	
				}
				
			}
			
			//The Pause Button
			if(btn == bPause){
				stop = true;
			}
			
			//The New Game Button
			if(btn == bNew){
				over = false;
				if(counter == 0){
					stop = false;
					th.start();
				}
				else{

					stop = false;
					label5.setText("  ");
					
					
					this.setPosition(210, 60);
					
					//set all the squares (200) empty
					for(int i = 0; i < 10; i++){
						for(int j =  0; j < 20; j++){
							filled[i][j] = false;
						}
					}
					currShape = initShape();
					nextShape = initShape();
					page.clearRect(60, 60, 300, 600);
					
					//buffer.getGraphics().clearRect(0,0,200,300);
					//this.getGraphics().clearRect(200,0,100,100);
					label4.setText("---");
					stop=false;
					synchronized(this)
					{
						notify();
					}
					repaint();
					
				}
			}
			
			requestFocus(true);
		}
	private class RadioButton implements ActionListener{
		public void actionPerformed(ActionEvent event){
			Object btm = (JRadioButton)event.getSource();
			if(btm == easyButton && over){
				time = TIME_EASY;
				gameType = 1;
			}
			if(btm == difficultButton && over){
				time = TIME_DIFFICULT;
				gameType = 2;
			}
			if(btm == hellButton && over){
				time = TIME_HELL;
				gameType = 3;
			}
			if(btm == infernoButton && over){
				time = TIME_INFERNO;
				gameType = 4;
			}
		}
	}
	
	/*
	//-----------------------------------------------------------
	//	Define the left button listener
	//-----------------------------------------------------------
	private class LeftListener implements ActionListener{
		public void actionPerformed(ActionEvent event){
			if(going && currShape.getLeft() > 60){
				xPos -= 30;
				currShape.setPlace(xPos, yPos);
			
				if(isFilled()){
					xPos += 30;
					currShape.setPlace(xPos, yPos);
				}
				repaint();
			}
		}
	}
	//-----------------------------------------------------------
	//	Define the right button listener
	//-----------------------------------------------------------
	private class RightListener implements ActionListener{
		public void actionPerformed(ActionEvent event){
			if(going && currShape.getRight() < 360){
				xPos += 30;
				currShape.setPlace(xPos, yPos);
				judgeLine();
				if(isFilled()){
					xPos -= 30;
					currShape.setPlace(xPos, yPos);
				}
				repaint();
			}
		}
	}
	//-----------------------------------------------------------
	//	Define the change button listener
	//-----------------------------------------------------------
	private class ChangeListener implements ActionListener{
		public void actionPerformed(ActionEvent event){
			if(going){
				currShape.rotate();
				currShape.setPlace(xPos, yPos);
				judgeLine();
				if(isFilled()){
					currShape.contraRotate();
					currShape.setPlace(xPos, yPos);
				}
				repaint();
			}
		}
	}
	//-----------------------------------------------------------
	//	Define the down button listener
	//-----------------------------------------------------------
	private class DownListener implements ActionListener{
		public void actionPerformed(ActionEvent event){
			if(going && currShape.getBottom() < 660){
				yPos += 30;
				currShape.setPlace(xPos, yPos);
				//judgeLine();
				if(isFilled()){
					yPos -= 30;
					currShape.setPlace(xPos, yPos);
					setFilled();
					next = true;
				}
				else if(currShape.getBottom() == 660){
					setFilled();
					next = true;
				}
				repaint();
			}
		}
	}
	
	//-----------------------------------------------------------
	//	Define the new game button listener
	//-----------------------------------------------------------
	private class NewListener implements ActionListener{
		public void actionPerformed(ActionEvent event){
			th.stop();
			th = new Thread();
			th.start();
			requestFocus(true);
		}
	}
	
	//-----------------------------------------------------------
	//	Define the start button listener
	//-----------------------------------------------------------
	
	private class StartListener implements ActionListener{
		public void actionPerformed(ActionEvent event){
			//going = true;
			if(counter == 0)
			{
				
				th.start();
				//requestFocus(true);
			}
			else
			{
				System.out.println("stop = false");
				stop = false;
				synchronized(this)
				{
					notify();
				}
			}
			repaint();
			requestFocus(true);
		}
	}
		
	
	
	//-----------------------------------------------------------
	//	Define the stop button listener
	//-----------------------------------------------------------
		
	private class PauseListener implements ActionListener{
		public void actionPerformed(ActionEvent event){
			stop = true;
		}
	}
_*/

	
	//-----------------------------------------------------------
	//	Check whether the specified row is filled
	//-----------------------------------------------------------
	public boolean isRowFull(int positions[]){
		boolean result = false;
		int yVal = positions[1];
		int topRow, counter = 0;
		for (; counter < 10; counter++){
			if(!filled[counter][yVal])
				break;
		}
		
		if(counter == 10){
			
			result = true;
			rowNum ++;
			scores = rowNum * BASE_SCORE;
			label4.setText(Integer.toString(scores));
			
			//adjust the time inverval according to the game type:1.easy, 2.difficult, 3.hell, 4.inferno
			if(gameType == 1){
			
				if(rowNum >= 10 && rowNum < 90){
					this.time = TIME_EASY - rowNum / 10 * 50;
					//System.out.println(this.time);
					
				}
				else if(rowNum >= 90 && rowNum < 170){
					this.time = 100 - (rowNum / 10 - 8) * 10;
				}
				else if(rowNum >= 170){
					this.time = 10;
				}
			}
			else if(gameType == 2){
				if(rowNum >= 10 && rowNum < 50){
					this.time = TIME_EASY - rowNum / 10 * 50;
					//System.out.println(this.time);
					
				}
				else if(rowNum >= 50 && rowNum < 130){
					this.time = 100 - (rowNum / 10 - 4) * 10;
				}
				else if(rowNum >= 130){
					this.time = 10;
				}
				
			}
			else if(gameType == 3){
				if(rowNum >= 90)
					this.time = 10;
				else if(rowNum >= 10)
					this.time = this.TIME_HELL - rowNum / 10 * 10;
			}
			else if(gameType == 4){
				if(rowNum >= 10)
					this.time = 40;
				else if(rowNum >= 20)
					this.time = 30;
				else if(rowNum >= 30)
					this.time = 20;
				else 
					this.time = 10;
			}
			
			this.topRow = getTopRow();
			
			for(int j = yVal; j > this.topRow; j-- ){
				//System.out.println(j);
				for(int k = 0; k < 10; k ++){
					filled[k][j] = filled[k][j - 1];
				}
			}
			
			for(int i = 0; i < 10; i++){
				filled[i][this.topRow] = false;
			}
		}
		
		return result;
	}
	
	//------------------------------------------------------------------------------
	// Get the top row of the filled array that are not empty
	//------------------------------------------------------------------------------
	public int getTopRow(){
		int j = 19;
		for(; j >= 0; j--){
			int k = 0;
			for(; k < 10; k ++){
				if(filled[k][j])
					break;		
			}
			if(k == 10)
				break;
		}
		return  (j - 1);
	}
}

