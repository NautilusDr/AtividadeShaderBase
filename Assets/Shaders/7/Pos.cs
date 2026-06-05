using UnityEngine;

public class Pos : MonoBehaviour
{
    Transform trans;

    private void Awake()
    {
        trans = transform.parent.transform;
        transform.parent = null;
    }

    private void Update()
    {
        transform.position = new Vector3(trans.position.x, 0, trans.position.z);
    }
}
