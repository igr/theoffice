// ---------------------------------------------------------------- domain

struct Team {
	members i64			// number of team members
	meetings f64		// meetings amount per day (percentage, accross the week)
	communication f64	// communication skills (percentage of unefficient communication, affects gaining knowledge)
}

struct Worker {
	utilisation f64		// (0-1] how much one is assigned to a project (percentage)
	efficiency f64		// (0-2] how effecient a worker is (percentage)
	knowledge f64		// (0-1] how much knowledge one has (percentage)
	learning f64		// (0-1] how many percents of knowledge one may get per time unit (percentage)
}

// calculate total working capabilities
fn calc_work_force(w Worker) f64 {	
	return w.utilisation * w.efficiency	
}

// calculates number of time units required to gain knowledge
fn calc_learning_needs(t Team, w Worker) f64 {
	return ((1 - w.knowledge) * w.learning) / t.communication
}

// calc additional time needed
fn calc_waste(t Team) f64 {
	return t.members * t.meetings / t.communication
}

fn calc_work(total_work i64, team Team, workers []Worker) f64 {	
	mut work_time := 0.0
	
	// clean work
	mut work_force := 0.0
	for w in workers {
		work_force += calc_work_force(w)
	}
	work_time += total_work / work_force

	// learning
	for w in workers {
		single_work_force := work_time * calc_work_force(w) / work_force
		work_time += single_work_force * calc_learning_needs(team, w)
	}

	// add meetings
	work_time += work_time * calc_waste(team)

	//for w in workers {
		//work_time += calc_learning_needs(team, w)
	//}	
	
	return work_time
}

// ---------------------------------------------------------------- actors :)

fn team_of(members i64, meetings f64, communication f64) Team {
	return Team {
		members: members
		meetings: meetings
		communication: communication
	}
}

const dwight = Worker {
	utilisation: 1.0
	efficiency: 1.0
	knowledge: 1.0
	learning: 1.0
}

const jim = Worker {
	utilisation: 0.9
	efficiency: 0.9
	knowledge: 1.0
	learning: 1.0
}

const stanley = Worker {
	utilisation: 0.9
	efficiency: 0.5
	knowledge: 0.5
	learning: 0.5
}

const kevin = Worker {
	utilisation: 0.9
	efficiency: 0.2
	knowledge: 0.5
	learning: 0.2
}

const ryan = Worker {
	utilisation: 0.9
	efficiency: 0.8
	knowledge: 0
	learning: 0.8
}


// ---------------------------------------------------------------- main

fn main() {
	print("Dwight is assistant (to the) regional manager: ")
	println(calc_work(100, team_of(1,0.1,1.0), [dwight]))
	print("Jim and Dwight are not doubling: ")
	println(calc_work(100, team_of(2,0.1,0.8), [dwight, jim]))
	print("But Kevin and Stanley are no good: ")
	println(calc_work(100, team_of(2,0.2,0.4), [kevin, stanley]))
	print("Jim and Dwight pranking (chatty): ")
	println(calc_work(100, team_of(2,0.5,0.5), [dwight, jim]))
	print("Good Dwight and new Ryan: ")
	println(calc_work(100, team_of(2,0.3,0.9), [dwight, ryan]))
}