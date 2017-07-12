var Rates = React.createClass({
  getInitialState: function() {
    return {
      indicators: this.props.indicators
    }
  },

  websoketSubscribeRate: function() {
    App.cable.subscriptions.create({ channel: "RatesChannel", room: 'rates' }, {
      connected: function() {
        console.log('connect');
      },
      disconnected: function() {
        console.log('disconnected');
      },
      received: function(data) {
        return this["ratesChannelCatch"](data);
      },
      "ratesChannelCatch": this["ratesChannelCatch"]
    });
  },

  ratesChannelCatch: function(response) {
    remote_ids = _.map(this.state.indicators, function(ind) { return ind.remote_id })

    index = _.indexOf(remote_ids, response.data.remote_id)
    const indicators = this.state.indicators
    indicators[index] = response.data

    $("table > tbody > tr:eq" + '(' + index + ')').effect("highlight", {}, 3000);

    this.setState({indicators: indicators })
  },

  componentWillMount: function() {

    this.websoketSubscribeRate()
  },

  render: function() {
    RatesIndicatorArray = this.state.indicators.map(function(indicator) {
      return <RatesIndicator indicator={indicator} key={'indicator_' + indicator.remote_id}/>
    })


    return (
      <table className="table table-hover">
        <tbody>
          { RatesIndicatorArray.length > 0 && RatesIndicatorArray }
        </tbody>
      </table>
    )
  }
})
