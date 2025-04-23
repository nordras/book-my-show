const MAX_CAPACITY = 1000000000;

class BookMyShow {
  constructor(n, m) {
    this.numRows = n - 1;
    this.seatsPerRow = m;
    this.maxFilledRow = -1;
    this.targetIndex = 0;
    this.remainingSeats = 0;
    const size = n * 4;
    this.maxSeats = new Uint32Array(size);
    this.cumulativeSeats = new Array(size).fill(0);
    this.initializeSeats(m, 0, 0, this.numRows);
  }

  initializeSeats(initialVal, node, left, right) {
    this.maxSeats[node] = initialVal;
    this.cumulativeSeats[node] = initialVal * (right - left + 1);
    if (left !== right) {
      const mid = (left + right) >> 1;
      this.initializeSeats(initialVal, node * 2 + 1, left, mid);
      this.initializeSeats(initialVal, node * 2 + 2, mid + 1, right);
    }
  }

  updateSeat(newVal, index, node, left, right) {
    if (index < left || index > right) return;
    if (left === right) {
      this.maxSeats[node] = newVal;
      this.cumulativeSeats[node] = newVal;
      return;
    }
    const mid = (left + right) >> 1;
    if (index <= mid) {
      this.updateSeat(newVal, index, node * 2 + 1, left, mid);
    } else {
      this.updateSeat(newVal, index, node * 2 + 2, mid + 1, right);
    }
    this.maxSeats[node] = Math.max(this.maxSeats[node * 2 + 1], this.maxSeats[node * 2 + 2]);
    this.cumulativeSeats[node] = this.cumulativeSeats[node * 2 + 1] + this.cumulativeSeats[node * 2 + 2];
  }

  markFilledRows(node, left, right) {
    if (left > this.maxFilledRow) return;
    if (right <= this.maxFilledRow) {
      this.maxSeats[node] = 0;
      this.cumulativeSeats[node] = 0;
      return;
    }
    const mid = (left + right) >> 1;
    this.markFilledRows(node * 2 + 1, left, mid);
    this.markFilledRows(node * 2 + 2, mid + 1, right);
    this.maxSeats[node] = Math.max(this.maxSeats[node * 2 + 1], this.maxSeats[node * 2 + 2]);
    this.cumulativeSeats[node] = this.cumulativeSeats[node * 2 + 1] + this.cumulativeSeats[node * 2 + 2];
  }

  searchForSeats(k, maxRow, node, left, right) {
    if (left > maxRow || this.maxSeats[node] < k) return;
    if (left === right) {
      this.targetIndex = left;
      this.remainingSeats = this.cumulativeSeats[node] - k;
      return;
    }
    const mid = (left + right) >> 1;
    this.searchForSeats(k, maxRow, node * 2 + 1, left, mid);
    if (this.targetIndex === MAX_CAPACITY) {
      this.searchForSeats(k, maxRow, node * 2 + 2, mid + 1, right);
    }
  }

  searchForScatteredSeats(k, maxRow, node, left, right) {
    if (left > maxRow || this.cumulativeSeats[node] < k) return;
    if (left === right) {
      this.targetIndex = left;
      this.remainingSeats = this.cumulativeSeats[node] - k;
      return;
    }
    const mid = (left + right) >> 1;
    if (this.cumulativeSeats[node * 2 + 1] >= k) {
      this.searchForScatteredSeats(k, maxRow, node * 2 + 1, left, mid);
    } else {
      this.searchForScatteredSeats(k - this.cumulativeSeats[node * 2 + 1], maxRow, node * 2 + 2, mid + 1, right);
    }
  }

  gather(k, maxRow) {
    this.targetIndex = MAX_CAPACITY;
    this.searchForSeats(k, maxRow, 0, 0, this.numRows);
    if (this.targetIndex === MAX_CAPACITY) return [];
    this.updateSeat(this.remainingSeats, this.targetIndex, 0, 0, this.numRows);
    return [this.targetIndex, this.seatsPerRow - this.remainingSeats - k];
  }

  scatter(k, maxRow) {
    this.targetIndex = MAX_CAPACITY;
    this.searchForScatteredSeats(k, maxRow, 0, 0, this.numRows);
    if (this.targetIndex === MAX_CAPACITY) return false;
    this.updateSeat(this.remainingSeats, this.targetIndex, 0, 0, this.numRows);
    this.maxFilledRow = this.targetIndex - 1;
    this.markFilledRows(0, 0, this.numRows);
    return true;
  }
}

// Test
const b = new BookMyShow(2, 5);
const output = [
  null,
  b.gather(4, 0),
  b.gather(2, 0),
  b.scatter(5, 1),
  b.scatter(5, 1)
];
console.log(output);
