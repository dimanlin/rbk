var RatesIndicator = React.createClass({
  getInitialState: function() {
    return {
      indicator: this.props.indicator
    }
  },

  componentWillReceiveProps: function(nextProps) {
    this.setState({ indicator: nextProps.indicator })
  },

  render: function() {
    return (
      <tr>
        <td>{this.state.indicator.subname}</td>
        <td>{this.state.indicator.name}</td>
        <td>{this.state.indicator.price}</td>
        <td>{this.state.indicator.chg_abs}</td>
      </tr>
    )
  }
})
