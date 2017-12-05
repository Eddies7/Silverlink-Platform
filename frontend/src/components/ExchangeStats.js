import React, { Component } from 'react';
import { connect } from 'react-redux';


class ExchangeStats extends Component {
	constructor(props) {
		super(props);

		this.state = {
			supply: '...',
			kilos: '...'
		}

		this.getExchangeStats = this.getExchangeStats.bind(this);
	}

	componentWillReceiveProps(nextProps) {
		if (this.props.LNKSExchange !== nextProps.LNKSExchange) {
			this.getExchangeStats(nextProps.LNKSExchange);
		}
	}

	getExchangeStats(LNKSExchange) {
		LNKSExchange.deployed().then(token => {
			token.getFee().then(fee => {
				this.setState({
					fee: this.props.web3.web3.fromWei(fee.toNumber(), 'ether')
				});
			});
		});

		setTimeout(() => {
			this.getExchangeStats(LNKSExchange);
		}, 2000);
	}

	render() {
		return (
			<div className="ExchangeStats container">
				<div className="row">
					<div className="col-xs-12">
						<h2>Exchange Info</h2>
						<h4>Fee: {this.state.fee} ETH</h4>
					</div>
				</div>
			</div>
		);
	}
};


function mapStateToProps(state) {
  return {
    LNKSExchange: state.LNKSExchange,
    account: state.account,
    web3: state.web3
  }
}

export default connect(mapStateToProps)(ExchangeStats);