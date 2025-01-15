import React, { useEffect, useState } from 'react';
import FlightCard from '../components/FlightCard';
import { fetchFlights } from '../api/flightApi';

const Flights = () => {
  const [flights, setFlights] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadFlights = async () => {
      const data = await fetchFlights();
      setFlights(data);
      setLoading(false);
    };

    loadFlights();
  }, []);

  if (loading) return <p>Loading flights...</p>;

  return (
    <div className="p-6">
      <h1 className="text-3xl font-bold mb-6">Available Flights</h1>
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
        {flights.map((flight, index) => (
          <FlightCard
            key={index}
            airline={flight.airline}
            from={flight.departure}
            to={flight.arrival}
            price={flight.price}
            duration={flight.duration}
          />
        ))}
      </div>
    </div>
  );
};

export default Flights;