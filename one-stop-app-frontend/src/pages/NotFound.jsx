import React from 'react';
import { Link } from 'react-router-dom';

const NotFound = () => {
  return (
    <div className="text-center py-10">
      <h1 className="text-2xl font-bold">404 - Page Not Found</h1>
      <Link to="/" className="text-blue-500">Go back to Home</Link>
    </div>
  );
};

export default NotFound;