import React from 'react';
import './ServiceGrid.css';

const services = [
  { name: "Hotels & Flights", icon: "🏨" },
  { name: "Hospitals & Police", icon: "🚑" },
  { name: "Shops & Restaurants", icon: "🛍️" },
  { name: "Car Rentals & Taxis", icon: "🚗" },
  { name: "Fashion Designers", icon: "👗" },
  { name: "Cinemas", icon: "🎬" },
];

const ServiceGrid = () => {
  return (
    <section className="service-grid">
      {services.map((service, index) => (
        <div key={index} className="service-card">
          <span>{service.icon}</span>
          <h3>{service.name}</h3>
        </div>
      ))}
    </section>
  );
};

export default ServiceGrid;