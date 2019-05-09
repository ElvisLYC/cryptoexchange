RSpec.describe 'Coinex integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:btc_bch_pair) { Cryptoexchange::Models::MarketPair.new(base: 'zrx', target: 'eth', market: 'coinex') }

  it 'fetch pairs' do
    pairs = client.pairs('coinex')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'coinex'
  end

  it 'give trade url' do
    trade_page_url = client.trade_page_url 'coinex', base: btc_bch_pair.base, target: btc_bch_pair.target
    expect(trade_page_url).to eq "https://www.coinex.com/trading?currency=ETH&dest=ZRX#limit"
  end

  it 'fetch ticker' do
    ticker = client.ticker(btc_bch_pair)

    expect(ticker.base).to eq 'ZRX'
    expect(ticker.target).to eq 'ETH'
    expect(ticker.market).to eq 'coinex'
    expect(ticker.high).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.last).to be_a Numeric
    expect(ticker.ask).to be_a Numeric
    expect(ticker.bid).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be nil
    expect(ticker.payload).to_not be nil
  end

  xit 'fetch order book' do
    order_book = client.order_book(btc_bch_pair)

    expect(order_book.base).to eq 'ZRX'
    expect(order_book.target).to eq 'ETH'
    expect(order_book.market).to eq 'coinex'
    expect(order_book.asks).to_not be_empty
    expect(order_book.bids).to_not be_empty
    expect(order_book.asks.first.price).to_not be_nil
    expect(order_book.bids.first.amount).to_not be_nil
    expect(order_book.bids.first.timestamp).to be_nil
    expect(order_book.asks.count).to be > 10
    expect(order_book.bids.count).to be > 10
    expect(order_book.timestamp).to be_a Numeric
    expect(order_book.payload).to_not be nil
  end

  it 'fetch trade' do
    trades = client.trades(btc_bch_pair)
    trade = trades.sample

    expect(trades).to_not be_empty
    expect(trade.trade_id).to_not be_nil
    expect(trade.base).to eq 'ZRX'
    expect(trade.target).to eq 'ETH'
    expect(['buy', 'sell']).to include trade.type
    expect(trade.price).to_not be_nil
    expect(trade.amount).to_not be_nil
    expect(trade.timestamp).to be_a Numeric
    expect(trade.payload).to_not be nil
    expect(trade.market).to eq 'coinex'
  end
end
