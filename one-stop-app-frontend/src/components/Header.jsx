import React from 'react';
import './Header.css';

const Header = () => {
  return (
    <header className="header">
      <div className="logo">One-Stop App</div>
      <nav>
        <ul>
          <li>Home</li>
          <li>Services</li>
          <li>Bookings</li>
          <li>Contact</li>
          <li>Profile</li>
        </ul>
      </nav>
    </header>
  );
};

export default Header;