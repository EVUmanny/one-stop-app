import React, { useEffect, useState } from 'react';
import HotelCard from '../components/HotelCard';
import { fetchHotels } from '../api/hotelApi';

const Hotels = () => {
  const [hotels, setHotels] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadHotels = async () => {
      const data = await fetchHotels();
      setHotels(data);
      setLoading(false);
    };

    loadHotels();
  }, []);

  if (loading) return <p>Loading hotels...</p>;

  return (
    <div className="p-6">
      <h1 className="text-3xl font-bold mb-6">Available Hotels</h1>
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
        {hotels.map((hotel, index) => (
          <HotelCard
            key={index}
            name={hotel.name}
            location={hotel.city}
            price={hotel.price}
            image={hotel.image || 'https://via.placeholder.com/300x200'}
          />
        ))}
      </div>
    </div>
  );
};

export default Hotels;