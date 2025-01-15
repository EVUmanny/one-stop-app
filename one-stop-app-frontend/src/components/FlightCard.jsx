import React from 'react';

const FlightCard = ({ airline, from, to, price, duration }) => {
  return (
    <div className="max-w-sm rounded overflow-hidden shadow-lg bg-white">
      <div className="px-6 py-4">
        <h2 className="font-bold text-xl mb-2">{airline}</h2>
        <p className="text-gray-700">{from} → {to}</p>
        <p className="text-gray-500">Duration: {duration}</p>
        <p className="text-green-600 font-semibold mt-2">${price}</p>
      </div>
      <div className="px-6 pb-4">
        <button className="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600">
          Book Flight
        </button>
      </div>
    </div>
  );
};

export default FlightCard;