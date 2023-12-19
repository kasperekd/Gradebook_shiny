document.addEventListener("DOMContentLoaded", function() {
  const canvas = document.getElementById("gameCanvas");
  const ctx = canvas.getContext("2d");
  canvas.width = 800;
  canvas.height = 400;
  
  let animationId;
  let ballX = canvas.width / 2;
  let ballY = canvas.height / 2;
  let ballSpeedX = 4;
  let ballSpeedY = 4;
  let player1Y = 150;
  let player2Y = 150;
  let player1Score = 0;
  let player2Score = 0;
  let opponentSpeed = 1;
  const paddleThickness = 10;
  const paddleHeight = 100;
  
  function drawRect(x, y, width, height, color) {
    ctx.fillStyle = color;
    ctx.fillRect(x, y, width, height);
  }

  function drawBall(x, y, radius, color) {
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.arc(x, y, radius, 0, Math.PI * 2, true);
    ctx.fill();
  }

  function update() {
    ballX += ballSpeedX;
    ballY += ballSpeedY;
	updateOpponentSpeed(); 
	updateOpponentPosition();

    if (ballY < 0 || ballY > canvas.height) {
      ballSpeedY = -ballSpeedY;
    }

    if (ballX < 20) {
      if (ballY > player1Y && ballY < player1Y + paddleHeight) {
        ballSpeedX = -ballSpeedX;
      } else {
        player2Score++;
        resetBall();
      }
    }
    if (ballX > canvas.width - 20) {
      if (ballY > player2Y && ballY < player2Y + paddleHeight) {
        ballSpeedX = -ballSpeedX;
      } else {
        player1Score++;
        resetBall();
      }
    }

    if (player1Score === 5 || player2Score === 5) {
		player1Score = 0;
		player2Score = 0;
		opponentSpeed = 1;
		resetBall();
    }
  
    drawRect(0, 0, canvas.width, canvas.height, 'black'); 
    drawRect(10, player1Y, paddleThickness, paddleHeight, 'white'); 
    drawRect(canvas.width - 20, player2Y, paddleThickness, paddleHeight, 'white');
    drawBall(ballX, ballY, 10, 'white'); 
    ctx.fillText(player1Score, 100, 100); 
    ctx.fillText(player2Score, canvas.width - 100, 100); 
  }

  function resetBall() {
    ballX = canvas.width / 2;
    ballY = canvas.height / 2;
    ballSpeedX = -ballSpeedX;
    ballSpeedY = 5;
  }

  function updatePlayerPosition(e) {
    const rect = canvas.getBoundingClientRect();
    const mouseY = e.clientY - rect.top - paddleHeight / 2;
    player1Y = mouseY;
  }
  
  canvas.addEventListener('mousemove', updatePlayerPosition);
  
  function gameLoop() {
    update();
    requestAnimationFrame(gameLoop);
  }
  
  function updateOpponentSpeed() {
  opponentSpeed = 1 + player1Score;
}
  
  function updateOpponentPosition() {
  if (player2Y + paddleHeight / 2 < ballY - 35) {
    player2Y += opponentSpeed;
  } else if (player2Y + paddleHeight / 2 > ballY + 35) {
    player2Y -= opponentSpeed;
  }
}
  
  gameLoop();
  
  document.addEventListener("visibilitychange", function() {
	  if (document.visibilityState === 'hidden') {
		cancelAnimationFrame(animationId); 

		player1Score = 0;
		player2Score = 0;
		opponentSpeed = 1;
		resetBall();
		
		ctx.clearRect(0, 0, canvas.width, canvas.height);
	  } else if (document.visibilityState === 'visible') {
		gameLoop(); 
		}	
	});
});

