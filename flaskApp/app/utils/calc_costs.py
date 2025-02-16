# Returns the cost of a journey if using a personal vehcile
def calc_cost_with_personal_vehicle(distance, passengers, days_parking):
    journey_cost = 0
    journey_cost_per_person = 0

    full_vehicles, extra_passengers = divmod(passengers, 4) # Can hold max 4 passengers

    if extra_passengers == 0:
        no_vehicles = full_vehicles
    else:
        no_vehicles = full_vehicles + 1

    journey_cost += no_vehicles*days_parking*5 # Parking costs £5 per day
    journey_cost += no_vehicles*distance*0.3 # Travel costs £0.3 per AU
    journey_cost_per_person = journey_cost / passengers # Find cost per passenger

    return journey_cost_per_person

# Returns cost of a journey if using HSTC vehicle
def calc_cost_with_hstc_transport(distance, passengers):
    journey_cost = 0
    journey_cost_per_person = 0

    full_vehicles, extra_passengers = divmod(passengers, 5) # Can hold max 5 passengers
    
    if extra_passengers == 0:
        no_vehicles = full_vehicles
    else:
        no_vehicles = full_vehicles + 1

    journey_cost += no_vehicles*distance*0.45 # Travel costs £0.45 per AU 
    journey_cost_per_person = journey_cost / passengers # Return cost per passenger

    return journey_cost_per_person