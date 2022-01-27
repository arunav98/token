const Token=artifacts.require('Token')
import {EVM_Revert, tokens} from './helper'

require('chai').use(require('chai-as-promised')).should()

contract('Token',([deployer,receiver])=>{
    let token
    const name='ArC Token',symbol='ArC',decimal='18',totalSupply=tokens(100000)
    beforeEach(async()=>{
        //fetch token from blockchain for each of it with the help of mocha
        token= await Token.new();
    })
    describe('deployment',()=>{
        
        it('track the name',async ()=>{
            
            //read token name
            const result=await token.name()
            //check the constrain
            result.should.be.a('string')
            result.should.equal(name)
        })

        it('track the symbol',async ()=>{
            const result=await token.symbol()
            result.should.equal(symbol)
        })

        it('track the decimal',async ()=>{
            const result=await token.decimal()
            result.toString().should.equal(decimal)
        })

        it('track the totalSupply',async ()=>{
            const result=await token.totalSupply()
            result.toString().should.equal(totalSupply.toString())
        })

        it('assign the totalSupply to  the deployer',async ()=>{
            const result=await token.balanceOf(deployer)
            result.toString().should.equal(totalSupply.toString())
        })
    })
    describe('send token',()=>{
        describe('success',async()=>{
            let amount
        let result
        beforeEach(async()=>{
            //transfer
            amount=tokens(250)
            result = await token.transfer(receiver,amount,{from: deployer})
        })
        it('tranfer token', async ()=>{
            let balanceOf
            //before transfer
            // balanceOf = await token.balanceOf(deployer)
            // console.log('before bal',balanceOf.toString())
            // balanceOf = await token.balanceOf(receiver)
            // console.log('before bal',balanceOf.toString())

            //after transfer
            balanceOf = await token.balanceOf(deployer)
            //console.log('After bal deployer ',balanceOf.toString())
            balanceOf = await token.balanceOf(receiver)
            //console.log('After bal receiver ',balanceOf.toString())
        })

        it('emit a tranfer event',async ()=>{
            const log =result.logs[0]
            log.event.should.eq('Transfer')
            const event = log.args
            event.from.toString().should.equal(deployer,'sender is correct')
            event.to.toString().should.equal(receiver,'receiver is correct')
            event.value.toString().should.equal(amount.toString(),'value is correct')
        })
        })

        describe('failure', async()=>{
            it('insufficient balance',async() => {
                let invalidAmount
                invalidAmount=tokens(10000000)
                await token.transfer(receiver,invalidAmount, {from: deployer}).should.be.rejectedWith(EVM_Revert)
            })

            it('invalid address',async() => {
                let invalidAmount
                invalidAmount=tokens(100)
                await token.transfer(0x0,invalidAmount, {from: deployer}).should.be.rejectedWith
            })
        })
    })
})