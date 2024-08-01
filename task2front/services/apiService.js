export async function fetchStatistics() {
    try {
      const response = await fetch('http://127.0.0.1:3000/api/v1/statistics');
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return await response.json();
    } catch (error) {
      console.error('Failed to fetch statistics:', error);
      return null;
    }
  }
  