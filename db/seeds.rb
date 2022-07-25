# frozen_string_literal: true

# rubocop:disable all
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

usd = Currency.create!({ name: 'USA Dollar', symbol: 'USD', logo: 'usd.png' })
rub = Currency.create!({ name: 'Russian Ruble', symbol: 'RUB', logo: 'rub.png' })

method = PaymentMethod.create!({ name: 'Cash' })

chain = Chain.create!({
                        name: 'Goerli Test Network',
                        explorer_address: 'https://goerli.etherscan.io/address/',
                        explorer_token: 'https://goerli.etherscan.io/token/',
                        explorer_tx: 'https://goerli.etherscan.io/tx/',
                        metamask_rpc: 'https://goerli.infura.io/v3/',
                        chain_id: 1,
                        chain_type: 'ETH'
                      })

xeenus = Token.create!({
                         address: '0x022E292b44B5a146F2e8ee36Ff44D3dd863C915c', chain: chain, decimals: 18,
                         p2p_address: '0x10Bd5B1F708761436FBb6bF975DC042AfB7cF70F',
                         arbiter_address: '0x5995dA46EB29aF756f713aBFe3e53000a477DFA8',
                         name: 'Xeenus 💪 Token', symbol: 'XEENUS', logo: 'empty-token.png', signer_address: nil,
                         signer_private_key_hex_encrypted: nil, fee: 0, signer_private_key_hex: nil
                       })
veenus = Token.create!({
                         address: '0xaFF4481D10270F50f203E0763e2597776068CBc5', chain: chain, decimals: 18,
                         p2p_address: '0xd3e846FdCbf7e6580363D1F6A399C7Db9F7eEE38',
                         arbiter_address: '0x5995dA46EB29aF756f713aBFe3e53000a477DFA8',
                         name: 'Weenus 💪 Token', symbol: 'WEENUS', logo: 'empty-token.png', signer_address: nil,
                         signer_private_key_hex_encrypted: nil, fee: 0, signer_private_key_hex: nil
                       })

Rate.create!({ token: xeenus, currency: usd, rate: 0.3e0 })
Rate.create!({ token: veenus, currency: usd, rate: 0.12348e3 })

seller = User.create!({ id: 1, eth_address: '0xB6429Fde856f2eC5F34D874676ba6d1760151191', uid: '1' })
buyer = User.create!({ id: 3, eth_address: '0xc920152164d484cd6ec0c1c9d8a228b56776badb', uid: '3' })
arbiter = User.create!({ id: 4, eth_address: '0x5995dA46EB29aF756f713aBFe3e53000a477DFA8', uid: '4' })

balance = Balance.create!({ user: seller, token: xeenus, locked: 10 })

offer_one = Offer.create!({
                            user: seller, token: xeenus, currency: usd, payment_method: method, balance: balance,
                            rate: 0.22244e3, min: 0.1e1, max: 0.3e1, terms: 'Fast and secure', active: false
                          })
offer_two = Offer.create!({
                            user: seller, token: xeenus, currency: rub, payment_method: method, balance: balance,
                            rate: 0.3e0, min: 0.4e1, max: 0.4e1, terms: 'Best trader', active: true
                          })

Deal.connection.schema_cache.clear!
Deal.reset_column_information

started_deal = Deal.create!({
                              id: 1, seller: seller, buyer: buyer, offer: offer_one, fee: 0, locked: 2, token: xeenus,
                              state: 'started', deadline_at: 1.week.since, internal_id: 1, signature: '1'
                            })
deal = Deal.create!({
                      id: 2, seller: seller, buyer: buyer, offer: offer_two, fee: 0, locked: 4, state: 'draft',
                      deadline_at: 1.week.since, internal_id: 2, token: xeenus,
                      signature: '80f8f5426f5369ffbf75dc9c4b5e377c2f7bb2787cced16900e463f02bd2203576a0e7404e3f45c618f4cbdda726e20ed367a6fcaf8be23ee4af6a377f6089021c'
                    })

chat = Chat.create!({ deal: started_deal })

file = File.open(File.join(Rails.root, '/spec/fixtures/files/photo.png'))

chat.messages.create!([
                     { message: 'Сообщение от продавца всем', author: seller, chat: chat, to: :both, file: nil, file_title: nil },
                     { message: 'Сообщение от покупателя всем', author: arbiter, chat: chat, to: :both, file: nil, file_title: nil },
                     { message: 'Сообщение от арбитра для продавца', author: arbiter, chat: chat, to: :seller, file: nil, file_title: nil },
                     { message: 'Сообщение от арбитра для покупателя', author: arbiter, chat: chat, to: :buyer, file: nil, file_title: nil },
                     { message: 'Сообщение от покупателя', author: buyer, chat: chat, to: :both, file: nil, file_title: nil },
                     { message: 'сообщение от продавца, покупателю', author: seller, chat: chat, to: :both, file: nil, file_title: nil },
                     { message: nil, author: seller, chat: chat, to: :both, file_title: 'Screenshot 2022-05-31 at 13.58.59.png', file: file },
                     { message: nil, author: seller, chat: chat, to: :both, file_title: 'Screenshot 2022-05-31 at 13.58.59.png', file: file },
                   ])
# rubocop:enable all