import React from 'react';

const ServiceCard = ({ name, description, icon }) => {
  return (
    <div className="max-w-sm rounded overflow-hidden shadow-lg bg-white flex items-center p-4">
      <img src={icon} alt={name} className="w-16 h-16 mr-4" />
      <div>
        <h2 className="font-bold text-xl mb-1">{name}</h2>
        <p className="text-gray-600">{description}</p>
      </div>
    </div>
  );
};

export default ServiceCard;