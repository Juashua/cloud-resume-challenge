/**
 * script.js - Visitor Counter
 * Calls the API Gateway endpoint to increment and display the visitor count.
 * Replace API_ENDPOINT with your deployed API Gateway URL.
 */

const API_ENDPOINT = 'https://wp05dksre9.execute-api.us-east-1.amazonaws.com/prod';

async function updateVisitorCount() {
  const countEl = document.getElementById('visitor-count');
  try {
    const response = await fetch(API_ENDPOINT, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
    });

    if (!response.ok) {
      throw new Error(`HTTP error: ${response.status}`);
    }

    const data = await response.json();
    countEl.textContent = data.count;
  } catch (error) {
    console.error('Failed to fetch visitor count:', error);
    countEl.textContent = 'N/A';
  }
}

document.addEventListener('DOMContentLoaded', updateVisitorCount);
