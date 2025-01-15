import React from 'react';

const HotelCard = ({ name, location, price, image }) => {
  return (
    <div className="max-w-sm rounded overflow-hidden shadow-lg bg-white">
      <img src={image} alt={name} className="w-full h-48 object-cover" />
      <div className="px-6 py-4">
        <h2 className="font-bold text-xl mb-2">{name}</h2>
        <p className="text-gray-700">{location}</p>
        <p className="text-blue-600 font-semibold mt-2">${price} / night</p>
      </div>
      <div className="px-6 pb-4">
        <button className="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-600">
          Book Now
        </button>
      </div>
    </div>
  );
};

export default HotelCard;