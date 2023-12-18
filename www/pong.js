document.addEventListener("DOMContentLoaded", function() {
  const canvas = document.getElementById("gameCanvas");
  const ctx = canvas.getContext("2d");
  canvas.width = 800;
  canvas.height = 400;
  
  // Установка начальных параметров мяча, платформ и счета
  let animationId;
  let ballX = canvas.width / 2;
  let ballY = canvas.height / 2;
  let ballSpeedX = 5;
  let ballSpeedY = 5;
  let player1Y = 150;
  let player2Y = 150;
  let player1Score = 0;
  let player2Score = 0;
  let opponentSpeed = 1;
  const paddleThickness = 10;
  const paddleHeight = 100;
  
  // Функция отрисовки прямоугольника
  function drawRect(x, y, width, height, color) {
    ctx.fillStyle = color;
    ctx.fillRect(x, y, width, height);
  }
  
  // Функция отрисовки мяча
  function drawBall(x, y, radius, color) {
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.arc(x, y, radius, 0, Math.PI * 2, true);
    ctx.fill();
  }
  
  // Функция обновления игрового поля и логики игры
  function update() {
    ballX += ballSpeedX;
    ballY += ballSpeedY;
	updateOpponentSpeed(); // Изменение скорости противника
	updateOpponentPosition();
  
      // Проверка столкновения мяча с верхней и нижней границей поля
    if (ballY < 0 || ballY > canvas.height) {
      ballSpeedY = -ballSpeedY;
    }
  
    // Проверка столкновения мяча с платформами
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
  
    // Проверка окончания игры
    if (player1Score === 5 || player2Score === 5) {
      // Код для окончания игры
    }
  
    // Обновление отображения
    drawRect(0, 0, canvas.width, canvas.height, 'black'); // Отрисовка фона
    drawRect(10, player1Y, paddleThickness, paddleHeight, 'white'); // Отрисовка платформы игрока 1
    drawRect(canvas.width - 20, player2Y, paddleThickness, paddleHeight, 'white'); // Отрисовка платформы игрока 2
    drawBall(ballX, ballY, 10, 'white'); // Отрисовка мяча
    ctx.fillText(player1Score, 100, 100); // Отображение счета игрока 1
    ctx.fillText(player2Score, canvas.width - 100, 100); // Отображение счета игрока 2
  }
  
  // Сброс мяча в центр поля
  function resetBall() {
    ballX = canvas.width / 2;
    ballY = canvas.height / 2;
    ballSpeedX = -ballSpeedX;
    ballSpeedY = 5;
  }
  
  // Обновление позиции платформ игроков
  function updatePlayerPosition(e) {
    const rect = canvas.getBoundingClientRect();
    const mouseY = e.clientY - rect.top - paddleHeight / 2;
    player1Y = mouseY;
  }
  
  // Обработчик движения мыши для управления платформой игрока 1
  canvas.addEventListener('mousemove', updatePlayerPosition);
  
  // Обновление игрового поля каждый кадр
  
  
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
  
  // Запуск игры
  gameLoop();
  
  document.addEventListener("visibilitychange", function() {
  if (document.visibilityState === 'hidden') {
    cancelAnimationFrame(animationId); // Поставить игру на паузу при скрытии канвы
    // Сброс значений игры
    player1Score = 0;
    player2Score = 0;
	opponentSpeed = 1;
    resetBall();
    // Очистить канву
    ctx.clearRect(0, 0, canvas.width, canvas.height);
  } else if (document.visibilityState === 'visible') {
    gameLoop(); // Возобновить игру при появлении канвы
  }
});
});




/* document.addEventListener("visibilitychange", function() {
  if (document.visibilityState === 'hidden') {
    // Поставить игру на паузу
	let ballX = canvas.width / 2;
	let ballY = canvas.height / 2;
	let ballSpeedX = 5;
	let ballSpeedY = 5;
	let player1Y = 150;
	let player2Y = 150;
	let player1Score = 0;
	let player2Score = 0;
	let opponentSpeed = 1;
	const paddleThickness = 10;
	const paddleHeight = 100;
	alert("hidden")
    cancelAnimationFrame(animationId); // Отменить анимацию
  } else if (document.visibilityState === 'visible') {
    // Возобновить игру
	alert("no hidden")
    gameLoop(); // Запустить игровой цикл заново
  }
}); */