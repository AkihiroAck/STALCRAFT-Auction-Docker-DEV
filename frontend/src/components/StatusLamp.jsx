import React from 'react';
import PropTypes from 'prop-types';
import './StatusLamp.css';

// Типы: status (статус последней загрузки), loading (процесс загрузки)
// Значения для status: 'none', 'success', 'timeout', 'error'
// Значения для loading: 'loading', 'idle'

const STATUS_COLORS = {
  none: 'lamp-off', // Серый, выключено
  success: 'lamp-success', // Зеленый
  timeout: 'lamp-timeout', // Оранжевый
  error: 'lamp-error', // Красный
};

const LOADING_COLORS = {
  loading: 'lamp-loading', // Синий или анимированный
  idle: 'lamp-off', // Серый
};

export default function StatusLamp({ type, value, className = '', ...props }) {
  let lampClass = '';
  if (type === 'status') {
    lampClass = STATUS_COLORS[value] || STATUS_COLORS.none;
  } else if (type === 'loading') {
    lampClass = LOADING_COLORS[value] || LOADING_COLORS.idle;
  }
  return (
    <div
      className={`status-lamp ${lampClass} ${className}`}
      role="status"
      aria-label={`Статус: ${type} - ${value}`}
      {...props}
    />
  );
}

StatusLamp.propTypes = {
  type: PropTypes.oneOf(['status', 'loading']).isRequired,
  value: PropTypes.string.isRequired,
  className: PropTypes.string,
};
