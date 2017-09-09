import { withStyles } from 'material-ui/styles';
import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import { fetchData } from '../../action/data';
import { changeRoute } from '../../action/route';
import styles from './data-styles';

class _Data extends Component {
  componentDidMount() {
    const { path } = this.props.route;
    this.props.fetchData(`/data${path}`);
  }

  render() {
    const { classes, data } = this.props;
    return (
      <div className={classes.wrap}>
        <h1 className={classes.title}>
          {data.title}
        </h1>
        <div className={classes.meta}>
          <span className={classes.author}>
            {data.author}
          </span>
          <span className={classes.date}>
            {data.date}
          </span>
        </div>
        <div dangerouslySetInnerHTML={{ __html: data.html }} />
      </div>
    );
  }
};

_Data.propTypes = {
  classes: PropTypes.object.isRequired,
  data: PropTypes.object.isRequired,
  fetchData: PropTypes.func.isRequired,
};

function mapStateToProps(state) {
  return {
    route: state.route,
    data: state.data,
  }
}

function mapDispatchToProps(dispatch) {
  return {
    fetchData: bindActionCreators(fetchData, dispatch),
  };
}

export const Data = connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(_Data));
