##  Shortest Path Algorithms(最短路径算法)

概念：

    1. c(e)，e属于E(G),用来表示这边e的权重/花销
    2. 从source到destination的路径长度用每一段路径的权重相加来获得
    3. 定义<v,v>=0 自己到自己的路径权重为0



## Single-Source Shortest-Path Problem

    先从简单的问题思考起步：先思考没有权重的有向图的算法该如何

## Unweight shortest Paths
辅助记忆：
    
    设置一个索引变量
    for(对索引做自增)
    {
        for(对于图中的每一个节点)
        {
            if(节点没有被作为基节点访问过周围节点&&节点的路径数值和索引值相同)
            {
                将这个节点设置为访问过了；
                for(当前节点的所相邻节点)
                {
                    if(这个节点的路径长度是无穷)
                    {
                        将其路径长度设置为当前索引+1；
                        将相邻节点的路径长度设置为索引+1；
                    }
                }
            }
        }
    }

伪代码
```C
void unweight_shortest_path(Table T,start v)
{
    int index;
    Vertex cur,adj;
    for(index=0;index<|T|;index++)
    {
        for(each Vertex V in T)
        {
            if(!T[V].known&&T[V].Dist==index)
            {
                T[V].known=true;
                for(each adj W of V)
                {
                    if(T[W].path==infinite)
                    {
                        T[W].Dist=index+1;
                        T[W],Path=V;
                    }
                }
            }
        }
    }
}
```
这个算法的时间复杂度是O（|V|^2^）
(Worst case: a linear list)


---

但是这个代码的时间复杂度还是太高了，我们完全每必要在每次寻找索引值和路径长度的时候对所有节点去做遍历，我们完全可以利用拓扑排序相类似的方式

---

#### Improvement (Using Queue)



代码如下

```C
void unweighted_shortest_path(Table T)
{
    int index;
    Vertex V,W;
    Q=createqueue(|T|);Makemepty(Q);
    enqueue(S,Q);
    while(!isempty(Q))
    {
        V=enqueue(Q);//入队的了的就必然满足是上一次操作的相邻元素
        T[V].known=true;
        for(each adj W of V)
        {
            if(T[W].Dist=infinite)//这一个无穷的判断还是必须有的，因为不无穷的我节点必然已经是更新过位置的！！！
            T[W].dist=T[V].Dist+1;//这里就不需要使用索引了，因为依靠迭代关系，直接使用上一次遍历的元素路径+1即可
            T[W].paht=V;
            enqueue(W,Q);
        }

    }
    DisposeQueue(Q);//记住队列用完之后一定要free掉！！！
}
```





    