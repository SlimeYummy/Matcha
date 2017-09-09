import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import { fetchData } from '../../action/data';
import { changeRoute } from '../../action/route';
import Catalog from '../catalog';
import Content from '../content';

class _Body extends Component {
  componentDidMount() {
    const { path } = this.props.route;
    this.props.fetchData(`/data${path}`);
  }

  shouldComponentUpdate(nextProps) {
    return nextProps.data.state !== 'discard';
  }

  render() {
    console.log(this.props);
    const { data } = this.props.data;
    if (data.type === 'catalog') {
      return <Catalog data={data} />;
    } else {
      return <Content data={data} />;
    }
  }
};

_Body.propTypes = {
  data: PropTypes.object.isRequired,
  route: PropTypes.object.isRequired,
  fetchData: PropTypes.func.isRequired,
};

function mapStateToProps(state) {
  console.log(state);
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

export const Body = connect(mapStateToProps, mapDispatchToProps)(_Body);
