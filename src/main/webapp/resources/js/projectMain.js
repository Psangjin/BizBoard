/**
 * 
 */
document.addEventListener('DOMContentLoaded', function () {
const circle = document.getElementById('progress-circle');
let text = document.getElementById('percentText');
const radius = circle.r.baseVal.value;
const circumference = 2 * Math.PI * radius;
let currentPercent = 0;

function setProgress(percent) {
	const offset = circumference - (percent / 100) * circumference;
	circle.style.strokeDashoffset = offset;
	text.textContent = percent + '%';
}

function changeProgress(change) {
	currentPercent = Math.min(100, Math.max(0, currentPercent + change));
	setProgress(currentPercent);
}

setProgress(currentPercent);

		
	});