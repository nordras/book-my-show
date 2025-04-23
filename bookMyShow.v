const max_capacity = 1_000_000_000

struct Booking {
mut:
	max_filled_row    int
	target_index      int
	remaining_seats   int
	num_rows          int
	seats_per_row     int
	max_seats         []u32
	cumulative_seats  []int
}

// Return the maximum of two u32 values
fn max_u32(a u32, b u32) u32 {
	return if a > b { a } else { b }
}

fn make_book_my_show(total_rows int, seats_per_row_val int) Booking {
	size := total_rows * 4
	mut theater := Booking {
		max_filled_row: -1
		target_index: 0
		remaining_seats: 0
		num_rows: total_rows - 1
		seats_per_row: seats_per_row_val
		max_seats: []u32{len: size, init: 0}
		cumulative_seats: []int{len: size, init: 0}
	}
	theater.initialize_seats(seats_per_row_val, 0, 0, theater.num_rows)
	return theater
}

fn (mut booking Booking) initialize_seats(initial_val int, node int, left int, right int) {
	booking.max_seats[node] = u32(initial_val)
	booking.cumulative_seats[node] = initial_val * (right - left + 1)
	if left != right {
		mid := (left + right) / 2
		booking.initialize_seats(initial_val, node * 2 + 1, left, mid)
		booking.initialize_seats(initial_val, node * 2 + 2, mid + 1, right)
	}
}

fn (mut booking Booking) update_seat(new_val int, index int, node int, left int, right int) {
	if index < left || index > right {
		return
	}
	if left == right {
		booking.max_seats[node] = u32(new_val)
		booking.cumulative_seats[node] = new_val
		return
	}
	mid := (left + right) / 2
	if index <= mid {
		booking.update_seat(new_val, index, node * 2 + 1, left, mid)
	} else {
		booking.update_seat(new_val, index, node * 2 + 2, mid + 1, right)
	}
	booking.max_seats[node] = max_u32(booking.max_seats[node * 2 + 1], booking.max_seats[node * 2 + 2])
	booking.cumulative_seats[node] = booking.cumulative_seats[node * 2 + 1] + booking.cumulative_seats[node * 2 + 2]
}

fn (mut booking Booking) mark_filled_rows(node int, left int, right int) {
	if left > booking.max_filled_row {
		return
	}
	if right <= booking.max_filled_row {
		booking.max_seats[node] = 0
		booking.cumulative_seats[node] = 0
		return
	}
	mid := (left + right) / 2
	booking.mark_filled_rows(node * 2 + 1, left, mid)
	booking.mark_filled_rows(node * 2 + 2, mid + 1, right)
	booking.max_seats[node] = max_u32(booking.max_seats[node * 2 + 1], booking.max_seats[node * 2 + 2])
	booking.cumulative_seats[node] = booking.cumulative_seats[node * 2 + 1] + booking.cumulative_seats[node * 2 + 2]
}

fn (mut booking Booking) search_for_seats(k int, max_row int, node int, left int, right int) {
	if left > max_row || int(booking.max_seats[node]) < k {
		return
	}
	if left == right {
		booking.target_index = left
		booking.remaining_seats = booking.cumulative_seats[node] - k
		return
	}
	mid := (left + right) / 2
	booking.search_for_seats(k, max_row, node * 2 + 1, left, mid)
	if booking.target_index == max_capacity {
		booking.search_for_seats(k, max_row, node * 2 + 2, mid + 1, right)
	}
}

fn (mut booking Booking) search_for_scattered_seats(k int, max_row int, node int, left int, right int) {
	if left > max_row || booking.cumulative_seats[node] < k {
		return
	}
	if left == right {
		booking.target_index = left
		booking.remaining_seats = booking.cumulative_seats[node] - k
		return
	}
	mid := (left + right) / 2
	if booking.cumulative_seats[node * 2 + 1] >= k {
		booking.search_for_scattered_seats(k, max_row, node * 2 + 1, left, mid)
	} else {
		booking.search_for_scattered_seats(k - booking.cumulative_seats[node * 2 + 1], max_row, node * 2 + 2, mid + 1, right)
	}
}

fn (mut booking Booking) gather(k int, max_row int) []int {
	booking.target_index = max_capacity
	booking.search_for_seats(k, max_row, 0, 0, booking.num_rows)

	if booking.target_index == max_capacity {
		return []int{}
	}

	booking.update_seat(booking.remaining_seats, booking.target_index, 0, 0, booking.num_rows)
	return [booking.target_index, booking.seats_per_row - booking.remaining_seats - k]
}

fn (mut booking Booking) scatter(k int, max_row int) bool {
	booking.target_index = max_capacity
	booking.search_for_scattered_seats(k, max_row, 0, 0, booking.num_rows)

	if booking.target_index == max_capacity {
		return false
	}

	booking.update_seat(booking.remaining_seats, booking.target_index, 0, 0, booking.num_rows)
	booking.max_filled_row = booking.target_index - 1
	booking.mark_filled_rows(0, 0, booking.num_rows)
	return true
}

fn main() {
	mut booking := make_book_my_show(2, 5)
	output := [
		'null',
		booking.gather(4, 0).str(),
		booking.gather(2, 0).str(),
		booking.scatter(5, 1).str(),
		booking.scatter(5, 1).str(),
	]
	println(output)
}
