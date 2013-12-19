import rank
import lib
if __name__ == "__main__":    
    a = lib.pairs("-cohen,0.3,--mittas,1,-a12,0.6")
    rank.ranks('data/ska.txt', a)
    rank.ranks('data/skb.txt', a)
    rank.ranks('data/skp.txt', a)    
    rank.ranks('data/skc.txt', a)
    rank.ranks('data/skd.txt', a)
    rank.ranks('data/ske.txt', a)    
   