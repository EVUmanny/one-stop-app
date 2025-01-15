import React from 'react';
import './Hero.css';

const Hero = () => {
  return (
    <section className="hero">
      <h1>Explore Nigeria with Ease</h1>
      <p>Hotels, Flights, Shops, Health, and more!</p>
      <div className="hero-buttons">
        <button>Book a Hotel</button>
        <button>Book a Flight</button>
        <button>Emergency Services</button>
      </div>
    </section>
  );
};

export default Hero;